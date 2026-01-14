//
//  ChatView.swift
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
import SwiftUIEKtensions

// Shared DateFormatter to avoid expensive instantiation
private let sharedDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.timeZone = .autoupdatingCurrent
    formatter.doesRelativeDateFormatting = true
    return formatter
}()

public struct ChatView<Message: ChatMessage, User: ChatUser>: View {

    @Binding private var messages: [Message]
    private var inputView: () -> AnyView
    private var customCellView: ((Any) -> AnyView)?

    private var onMessageCellTapped: (Message) -> Void = { msg in print(msg.messageKind) }
    private var messageCellContextMenu: (Message) -> AnyView = { _ in EmptyView().embedInAnyView() }
    private var onQuickReplyItemSelected: (QuickReplyItem) -> Void = { _ in }
    private var contactCellFooterSection: (ContactItem, Message) -> [ContactCellButton] = { _, _ in [] }
    private var onCarouselItemAction: (CarouselItemButton, Message) -> Void = { (_, _) in }
    private var inset: EdgeInsets
    private var dateHeaderTimeInterval: TimeInterval
    private var shouldShowGroupChatHeaders: Bool
    private var reachedTop: (() -> Void)?
    
    // Cache for message metadata to avoid O(n) lookups per message
    @State private var messageMetadataCache: [Message.ID: (showDateHeader: Bool, showDisplayName: Bool)] = [:]

    @Binding private var scrollTo: UUID?
    @Binding private var scrollToBottom: Bool

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                chatView(in: geometry)
                    .safeAreaInset(
                        edge: .bottom,
                        content: inputView
                    )

                PIPVideoCell<Message>()
            }
            .keyboardAwarePadding() // iOS only
        }
#if os(iOS)
        .environmentObject(DeviceOrientationInfo())
#endif
        .environmentObject(VideoManager<Message>())
        .edgesIgnoringSafeArea(.bottom)
        .dismissKeyboardOnTappingOutside() // iOS only
    }

    private func chatView(in geometry: GeometryProxy) -> some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(messages) { message in
                        MessageRow(
                            message: message,
                            metadata: messageMetadataCache[message.id] ?? (showDateHeader: false, showDisplayName: false),
                            geometrySize: geometry.size,
                            chatMessageViewContainer: { msg, showName in
                                chatMessageViewContainer(in: geometry.size, with: msg, with: showName)
                            },
                            onFirstMessageAppear: {
                                self.reachedTop?()
                            },
                            isFirstMessage: message.id == self.messages.first?.id
                        )
                        .id(message.id)
                    }
                    Spacer()
                        .frame(height: 0)
                        .id("bottom")
                }
                .padding(inset)
            }
            .onChange(of: messages.map(\.id)) { _ in
                rebuildMessageMetadataCache()
            }
            .onChange(of: scrollToBottom) { value in
                if value {
                    withAnimation {
                        proxy.scrollTo("bottom")
                    }
                    scrollToBottom = false
                }
            }
            .onChange(of: scrollTo) { value in
                if let value {
                    proxy.scrollTo(value, anchor: .top)
                    scrollTo = nil
                }
            }
#if os(iOS)
            // Auto Scroll with Keyboard Notification
            .onReceive(
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillShowNotification)
                    .debounce(for: .milliseconds(400), scheduler: RunLoop.main),
                perform: { _ in
                    if !scrollToBottom {
                        scrollToBottom = true
                    }
                }
            )
#endif
        }
        .background(Color.clear)
    }

}

private extension ChatView {
    // MARK: - List Item
    private func chatMessageViewContainer(
        in size: CGSize,
        with message: Message,
        with avatarShow: Bool
    ) -> some View {
        ChatMessageViewContainer(
            message: message,
            size: size,
            customCell: customCellView,
            onQuickReplyItemSelected: onQuickReplyItemSelected,
            contactFooterSection: contactCellFooterSection,
            onCarouselItemAction: onCarouselItemAction
        )
        .onTapGesture { onMessageCellTapped(message) }
        .contextMenu(menuItems: { messageCellContextMenu(message) })
        .modifier(
            AvatarModifier<Message>(
                message: message,
                showAvatarForMessage: shouldShowAvatarForMessage(
                    forThisMessage: avatarShow
                )
            )
        )
        .modifier(MessageHorizontalAlignmentModifier(messageKind: message.messageKind, isSender: message.isSender))
        .modifier(MessageViewEdgeInsetsModifier(isSender: message.isSender))
        .id(message.id)
    }
}

private extension ChatView {
    func rebuildMessageMetadataCache() {
        var newCache: [Message.ID: (showDateHeader: Bool, showDisplayName: Bool)] = [:]
        
        for (index, message) in messages.enumerated() {
            let showDateHeader: Bool
            if index == 0 {
                showDateHeader = true
            } else {
                let prevMessage = messages[index]
                let currMessage = messages[index - 1]
                let timeInterval = prevMessage.date - currMessage.date
                showDateHeader = timeInterval > dateHeaderTimeInterval
            }
            
            let showDisplayName: Bool
            if !shouldShowGroupChatHeaders {
                showDisplayName = false
            } else if showDateHeader {
                showDisplayName = true
            } else if index == 0 {
                showDisplayName = true
            } else {
                let prevMessageUserID = messages[index].user.id
                let currMessageUserID = messages[index - 1].user.id
                showDisplayName = prevMessageUserID != currMessageUserID
            }
            
            newCache[message.id] = (showDateHeader, showDisplayName)
        }
        
        messageMetadataCache = newCache
    }
    
    func shouldShowDateHeader(messages: [Message], thisMessage: Message) -> Bool {
        if let messageIndex = messages.firstIndex(where: { $0.id == thisMessage.id }) {
            if messageIndex == 0 { return true }
            let prevMessage = messages[messageIndex]
            let currMessage = messages[messageIndex - 1]
            let timeInterval = prevMessage.date - currMessage.date
            return timeInterval > dateHeaderTimeInterval
        }
        return false
    }

    func shouldShowDisplayName(
        messages: [Message],
        thisMessage: Message,
        dateHeaderShown: Bool
    ) -> Bool {
        if !shouldShowGroupChatHeaders {
            return false
        } else if dateHeaderShown {
            return true
        }

        if let messageIndex = messages.firstIndex(where: { $0.id == thisMessage.id }) {
            if messageIndex == 0 {
                return true
            }

            let prevMessageUserID = messages[messageIndex].user.id
            let currMessageUserID = messages[messageIndex - 1].user.id
            let isDifferentUser = prevMessageUserID != currMessageUserID

            return isDifferentUser
        }

        return false
    }

    func shouldShowAvatarForMessage(forThisMessage: Bool) -> Bool {
        (forThisMessage || !shouldShowGroupChatHeaders)
    }
}

// MARK: - Cache Building
private extension ChatView {
    static func buildInitialCache(
        messages: [Message],
        dateHeaderTimeInterval: TimeInterval,
        shouldShowGroupChatHeaders: Bool
    ) -> [Message.ID: (showDateHeader: Bool, showDisplayName: Bool)] {
        var cache: [Message.ID: (showDateHeader: Bool, showDisplayName: Bool)] = [:]
        
        for (index, message) in messages.enumerated() {
            let showDateHeader: Bool
            if index == 0 {
                showDateHeader = true
            } else {
                let prevMessage = messages[index]
                let currMessage = messages[index - 1]
                let timeInterval = prevMessage.date - currMessage.date
                showDateHeader = timeInterval > dateHeaderTimeInterval
            }
            
            let showDisplayName: Bool
            if !shouldShowGroupChatHeaders {
                showDisplayName = false
            } else if showDateHeader {
                showDisplayName = true
            } else if index == 0 {
                showDisplayName = true
            } else {
                let prevMessageUserID = messages[index].user.id
                let currMessageUserID = messages[index - 1].user.id
                showDisplayName = prevMessageUserID != currMessageUserID
            }
            
            cache[message.id] = (showDateHeader, showDisplayName)
        }
        
        return cache
    }
}

// MARK: - Initializers
public extension ChatView {
    /// ChatView constructor
    /// - Parameters:
    ///   - messages: Messages to display
    ///   - scrollToBottom: set to `true` to scrollToBottom
    ///   - dateHeaderTimeInterval: Amount of time between messages in
    ///                             seconds required before dateheader added
    ///                             (Default 1 hour)
    ///   - shouldShowGroupChatHeaders: Shows the display name of the sending
    ///                                 user only if it is the first message in a chain.
    ///                                 Also only shows avatar for first message in chain.
    ///                                 (disabled by default)
    ///   - inputView: inputView view to provide message
    ///
    init(
        messages: Binding<[Message]>,
        scrollToBottom: Binding<Bool> = .constant(false),
        scrollTo: Binding<UUID?> = .constant(nil),
        dateHeaderTimeInterval: TimeInterval = 3600,
        shouldShowGroupChatHeaders: Bool = false,
        inputView: @escaping () -> AnyView,
        inset: EdgeInsets = .init(),
        reachedTop: (() -> Void)? = nil
    ) {
        _messages = messages
        self.inputView = inputView
        _scrollToBottom = scrollToBottom
        self.inset = inset
        self.dateHeaderTimeInterval = dateHeaderTimeInterval
        self.shouldShowGroupChatHeaders = shouldShowGroupChatHeaders
        self.reachedTop = reachedTop
        _scrollTo = scrollTo
        
        // Initialize metadata cache
        _messageMetadataCache = State(initialValue: Self.buildInitialCache(
            messages: messages.wrappedValue,
            dateHeaderTimeInterval: dateHeaderTimeInterval,
            shouldShowGroupChatHeaders: shouldShowGroupChatHeaders
        ))
    }
}

public extension ChatView {
    /// Registers a custom cell view
    func registerCustomCell(customCell: @escaping (Any) -> AnyView) -> Self {
        then({ $0.customCellView = customCell})
    }

    /// Triggered when a ChatMessage is tapped.
    func onMessageCellTapped(_ action: @escaping (Message) -> Void) -> Self {
        then({ $0.onMessageCellTapped = action })
    }

    /// Present ContextMenu when a message cell is long pressed.
    func messageCellContextMenu(_ action: @escaping (Message) -> AnyView) -> Self {
        then({ $0.messageCellContextMenu = action })
    }

    /// Triggered when a quickReplyItem is selected (ChatMessageKind.quickReply)
    func onQuickReplyItemSelected(_ action: @escaping (QuickReplyItem) -> Void) -> Self {
        then({ $0.onQuickReplyItemSelected = action })
    }

    /// Present contactItem's footer buttons. (ChatMessageKind.contactItem)
    func contactItemButtons(_ section: @escaping (ContactItem, Message) -> [ContactCellButton]) -> Self {
        then({ $0.contactCellFooterSection = section })
    }

    /// Triggered when the carousel button tapped.
    func onCarouselItemAction(action: @escaping (CarouselItemButton, Message) -> Void) -> Self {
        then({ $0.onCarouselItemAction = action })
    }
}

// MARK: - MessageRow for better scroll performance
private struct MessageRow<Message: ChatMessage, Content: View>: View {
    let message: Message
    let metadata: (showDateHeader: Bool, showDisplayName: Bool)
    let geometrySize: CGSize
    let chatMessageViewContainer: (Message, Bool) -> Content
    let onFirstMessageAppear: () -> Void
    let isFirstMessage: Bool
    
    var body: some View {
        VStack(alignment: message.isSender ? .trailing : .leading, spacing: 2) {
            if metadata.showDateHeader {
                Text(sharedDateFormatter.string(from: message.date))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 4)
            }
            
            if metadata.showDisplayName {
                Text(message.user.userName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(
                        maxWidth: geometrySize.width * (Device.isLandscape ? 0.6 : 0.75),
                        alignment: message.isSender ? .trailing : .leading
                    )
            }
            
            chatMessageViewContainer(message, metadata.showDisplayName)
        }
        .onAppear {
            if isFirstMessage {
                onFirstMessageAppear()
            }
        }
    }
}
