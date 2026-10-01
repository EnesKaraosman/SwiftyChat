//
//  ChatView.swift
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

// Shared DateFormatter to avoid expensive instantiation
private let sharedDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.timeZone = .autoupdatingCurrent
    formatter.doesRelativeDateFormatting = true
    return formatter
}()

/// The main chat interface view that displays messages and an input bar.
///
/// `ChatView` renders a scrollable list of messages with automatic date headers,
/// avatar grouping, keyboard handling, and picture-in-picture video support.
///
/// Use view modifiers to handle interactions:
/// - ``onMessageCellTapped(_:)`` — respond to message taps
/// - ``onQuickReplyItemSelected(_:)`` — handle quick reply selection
/// - ``onCarouselItemAction(action:)`` — handle carousel button taps
/// - ``messageCellContextMenu(_:)`` — add long-press context menus
/// - ``onLinkPreviewTapped(_:)`` — handle link preview taps
/// - ``contactItemButtons(_:)`` — provide contact card action buttons
/// - ``registerCustomCell(customCell:)`` — render ``ChatMessageKind/custom(_:)`` messages
///
/// Style the chat by injecting a ``ChatMessageCellStyle`` via the environment:
/// ```swift
/// .environment(\.chatStyle, ChatMessageCellStyle())
/// ```
public struct ChatView<Message: ChatMessage, InputView: View>: View {

    @Binding private var messages: [Message]
    private var inputView: () -> InputView
    private var customCellView: ((Any) -> AnyView)?

    private var onMessageCellTapped: (Message) -> Void = { msg in print(msg.messageKind) }
    private var messageCellContextMenu: (Message) -> AnyView = { _ in AnyView(EmptyView()) }
    private var onQuickReplyItemSelected: (QuickReplyItem) -> Void = { _ in }
    private var contactCellFooterSection: (ContactItem, Message) -> [ContactCellButton] = { _, _ in [] }
    private var onCarouselItemAction: (CarouselItemButton, Message) -> Void = { (_, _) in }
    private var onLinkPreviewTapped: (URL, Message) -> Void = { (_, _) in }
    private var inset: EdgeInsets
    private var dateHeaderTimeInterval: TimeInterval
    private var shouldShowGroupChatHeaders: Bool
    private var reachedTop: (() -> Void)?
    
    @State private var videoManager = VideoManager<Message>()
    @State private var visibleBottomMessageID: Message.ID?
    @State private var hasReachedBottom = false
    @State private var topReachTracker = TopReachTracker<Message.ID>()

    @Binding private var scrollTo: Message.ID?
    @Binding private var scrollToBottom: Bool

    @State private var containerSize: CGSize = .zero
    #if os(iOS)
    @State private var keyboardHeight: CGFloat = 0
    #endif

    public var body: some View {
        let messageMetadata = MessageMetadataBuilder.build(
            messages,
            dateHeaderTimeInterval: dateHeaderTimeInterval,
            shouldShowGroupChatHeaders: shouldShowGroupChatHeaders
        )

        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(messages) { message in
                        MessageRow(
                            message: message,
                            metadata: messageMetadata[message.id] ?? MessageMetadata(showDateHeader: false, showDisplayName: false),
                            geometrySize: containerSize,
                            chatMessageViewContainer: { msg, showName in
                                chatMessageViewContainer(in: containerSize, with: msg, with: showName)
                            },
                            onFirstMessageAppear: {
                                if self.reachedTop != nil && self.topReachTracker.shouldReport(message.id, isReady: hasReachedBottom) {
                                    self.reachedTop?()
                                }
                            },
                            isFirstMessage: message.id == self.messages.first?.id
                        )
                        .id(message.id)
                    }
                }
                .padding(inset)
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .defaultScrollAnchor(.bottom)
            .scrollPosition(id: $visibleBottomMessageID, anchor: .bottom)
            .safeAreaInset(edge: .bottom) {
                inputView()
            }
            .onChange(of: messages.map(\.id)) { oldIDs, newIDs in
                if newIDs.isEmpty { hasReachedBottom = false }
                if let target = MessageScrollPolicy.targetAfterUpdate(
                    oldIDs: oldIDs,
                    newIDs: newIDs,
                    visibleBottomID: visibleBottomMessageID
                ) {
                    if oldIDs.isEmpty {
                        visibleBottomMessageID = target
                    } else {
                        withAnimation(.easeOut(duration: 0.2)) {
                            proxy.scrollTo(target, anchor: .bottom)
                        }
                    }
                }
            }
            .onChange(of: visibleBottomMessageID) { _, visibleID in
                if visibleID == messages.last?.id, visibleID != nil {
                    hasReachedBottom = true
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
            onCarouselItemAction: onCarouselItemAction,
            onLinkPreviewTapped: onLinkPreviewTapped
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
    func shouldShowAvatarForMessage(forThisMessage: Bool) -> Bool {
        (forThisMessage || !shouldShowGroupChatHeaders)
    }
}

// MARK: - Initializers
public extension ChatView {
    /// Creates a new chat view.
    /// - Parameters:
    ///   - messages: Binding to the array of messages to display.
    ///   - scrollToBottom: Set to `true` to programmatically scroll to the newest message.
    ///   - scrollTo: Set to a message ID to scroll to that specific message.
    ///   - dateHeaderTimeInterval: Minimum seconds between messages before a date header is shown (default: 3600).
    ///   - shouldShowGroupChatHeaders: When `true`, shows display names and groups avatars by sender (default: `false`).
    ///   - inputView: A view builder that provides the message input bar.
    ///   - inset: Edge insets applied to the message list.
    ///   - reachedTop: Called when the user scrolls to the first message (useful for pagination).
    init(
        messages: Binding<[Message]>,
        scrollToBottom: Binding<Bool> = .constant(false),
        scrollTo: Binding<Message.ID?> = .constant(nil),
        dateHeaderTimeInterval: TimeInterval = 3600,
        shouldShowGroupChatHeaders: Bool = false,
        @ViewBuilder inputView: @escaping () -> InputView,
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
        
    }
}

public extension ChatView {
    /// Registers a custom cell view for `ChatMessageKind.custom`.
    func registerCustomCell<Content: View>(@ViewBuilder customCell: @escaping (Any) -> Content) -> Self {
        var view = self
        view.customCellView = { data in AnyView(customCell(data)) }
        return view
    }

    /// Triggered when a ChatMessage is tapped.
    func onMessageCellTapped(_ action: @escaping (Message) -> Void) -> Self {
        var view = self
        view.onMessageCellTapped = action
        return view
    }

    /// Present ContextMenu when a message cell is long pressed.
    func messageCellContextMenu<MenuContent: View>(@ViewBuilder _ action: @escaping (Message) -> MenuContent) -> Self {
        var view = self
        view.messageCellContextMenu = { msg in AnyView(action(msg)) }
        return view
    }

    /// Triggered when a quickReplyItem is selected (ChatMessageKind.quickReply)
    func onQuickReplyItemSelected(_ action: @escaping (QuickReplyItem) -> Void) -> Self {
        var view = self
        view.onQuickReplyItemSelected = action
        return view
    }

    /// Present contactItem's footer buttons. (ChatMessageKind.contactItem)
    func contactItemButtons(_ section: @escaping (ContactItem, Message) -> [ContactCellButton]) -> Self {
        var view = self
        view.contactCellFooterSection = section
        return view
    }

    /// Triggered when the carousel button tapped.
    func onCarouselItemAction(action: @escaping (CarouselItemButton, Message) -> Void) -> Self {
        var view = self
        view.onCarouselItemAction = action
        return view
    }

    /// Triggered when a link preview message is tapped.
    func onLinkPreviewTapped(_ action: @escaping (URL, Message) -> Void) -> Self {
        var view = self
        view.onLinkPreviewTapped = action
        return view
    }
}

// MARK: - MessageRow for better scroll performance
private struct MessageRow<Message: ChatMessage, Content: View>: View {
    let message: Message
    let metadata: MessageMetadata
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
                        maxWidth: geometrySize.width * (geometrySize.isChatLandscape ? 0.6 : 0.75),
                        alignment: message.isSender ? .trailing : .leading
                    )
            }
            
            chatMessageViewContainer(message, metadata.showDisplayName)

            if message.isSender, let status = message.deliveryStatus {
                Text(status.rawValue.capitalized)
                    .font(.caption2)
                    .foregroundStyle(status == .failed ? .red : .secondary)
                    .accessibilityLabel("Message \(status.rawValue)")
            }
        }
        .onAppear {
            if isFirstMessage {
                onFirstMessageAppear()
            }
        }
    }
}
