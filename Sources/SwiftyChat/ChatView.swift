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
    @State private var videoManager = VideoManager<Message>()

    @Binding private var scrollTo: UUID?
    @Binding private var scrollToBottom: Bool

    @State private var containerSize: CGSize = .zero
    #if os(iOS)
    @State private var keyboardHeight: CGFloat = 0
    #endif

    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(messages) { message in
                        MessageRow(
                            message: message,
                            metadata: messageMetadataCache[message.id] ?? (showDateHeader: false, showDisplayName: false),
                            geometrySize: containerSize,
                            chatMessageViewContainer: { msg, showName in
                                chatMessageViewContainer(in: containerSize, with: msg, with: showName)
                            },
                            onFirstMessageAppear: {
                                self.reachedTop?()
                            },
                            isFirstMessage: message.id == self.messages.first?.id
                        )
                        .id(message.id)
                    }
                }
                .padding(inset)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .defaultScrollAnchor(.bottom)
            .safeAreaInset(edge: .bottom) {
                inputView()
            }
            .onChange(of: messages.count) {
                rebuildMessageMetadataCache()
                if let last = messages.last {
                    withAnimation(.easeOut(duration: 0.2)) {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
            .onChange(of: scrollToBottom) { oldValue, newValue in
                if newValue {
                    if let last = messages.last {
                        withAnimation(.easeOut(duration: 0.2)) {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                    scrollToBottom = false
                }
            }
            .onChange(of: scrollTo) { oldValue, newValue in
                if let newValue {
                    proxy.scrollTo(newValue, anchor: .top)
                    scrollTo = nil
                }
            }
        }
        #if os(iOS)
        .offset(y: -keyboardHeight)
        .ignoresSafeArea(.keyboard)
        .onReceive(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        ) { notification in
            if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let bottomInset = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene }).first?
                    .windows.first?.safeAreaInsets.bottom ?? 0
                withAnimation(Self.keyboardAnimation(from: notification)) {
                    keyboardHeight = frame.height - bottomInset
                }
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
        ) { notification in
            withAnimation(Self.keyboardAnimation(from: notification)) {
                keyboardHeight = 0
            }
        }
        #endif
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newSize in
            containerSize = newSize
        }
        .overlay(alignment: .bottom) {
            PIPVideoCell<Message>()
        }
#if os(iOS)
        .environmentObject(DeviceOrientationInfo())
#endif
        .environment(videoManager)
        .dismissKeyboardOnTappingOutside()
    }

    #if os(iOS)
    private static func keyboardAnimation(from notification: Notification) -> Animation {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        let curveRaw = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 7
        if curveRaw == 7 {
            // iOS keyboard uses a custom spring curve (raw value 7)
            return .spring(duration: duration, bounce: 0, blendDuration: 0)
        }
        return .easeOut(duration: duration)
    }
    #endif

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
                let currMessage = messages[index]
                let prevMessage = messages[index - 1]
                let timeInterval = currMessage.date - prevMessage.date
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
                let currMessageUserID = messages[index].user.id
                let prevMessageUserID = messages[index - 1].user.id
                showDisplayName = currMessageUserID != prevMessageUserID
            }

            newCache[message.id] = (showDateHeader, showDisplayName)
        }

        messageMetadataCache = newCache
    }
    
    func shouldShowDateHeader(messages: [Message], thisMessage: Message) -> Bool {
        if let messageIndex = messages.firstIndex(where: { $0.id == thisMessage.id }) {
            if messageIndex == 0 { return true }
            let currMessage = messages[messageIndex]
            let prevMessage = messages[messageIndex - 1]
            let timeInterval = currMessage.date - prevMessage.date
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

            let currMessageUserID = messages[messageIndex].user.id
            let prevMessageUserID = messages[messageIndex - 1].user.id
            let isDifferentUser = currMessageUserID != prevMessageUserID

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
                let currMessage = messages[index]
                let prevMessage = messages[index - 1]
                let timeInterval = currMessage.date - prevMessage.date
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
                let currMessageUserID = messages[index].user.id
                let prevMessageUserID = messages[index - 1].user.id
                showDisplayName = currMessageUserID != prevMessageUserID
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
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 4)
            }
            
            if metadata.showDisplayName {
                Text(message.user.userName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
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
