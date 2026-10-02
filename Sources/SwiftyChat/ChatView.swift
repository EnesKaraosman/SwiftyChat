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
    private var onReplyPreviewTapped: ((Message) -> Void)?
    private var onRetryMessage: ((Message) -> Void)?
    private var onReachedBottom: ((Message.ID) -> Void)?
    private var unreadMessageIDs: Set<Message.ID> = []
    private var showsScrollToBottomButton = false
    private var inset: EdgeInsets
    private var dateHeaderTimeInterval: TimeInterval
    private var shouldShowGroupChatHeaders: Bool
    private var reachedTop: (() -> Void)?
    
    @State private var videoManager = VideoManager<Message>()
    @State private var scrollState = MessageScrollState()
    @State private var hasReachedBottom = false
    @State private var topReachTracker = TopReachTracker<Message.ID>()
    @State private var bottomPosition: MessageBottomPosition<Message.ID>?
    @State private var viewportBounds: CGRect = .zero
    @Namespace private var scrollCoordinateSpace

    @Binding private var scrollTo: Message.ID?
    @Binding private var scrollToBottom: Bool

    @State private var containerSize: CGSize = .zero

    public var body: some View {
        let messageMetadata = MessageMetadataBuilder.build(
            messages,
            dateHeaderTimeInterval: dateHeaderTimeInterval,
            shouldShowGroupChatHeaders: shouldShowGroupChatHeaders
        )
        let navigation = MessageNavigationState(
            messages: messages,
            unreadMessageIDs: unreadMessageIDs
        )
        let reachedBottomID = bottomPosition?.reachedMessageID(in: viewportBounds, lastMessageID: messages.last?.id)

        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(messages) { message in
                        MessageRow(
                            message: message,
                            metadata: messageMetadata[message.id] ?? MessageMetadata(showDateHeader: false, showDisplayName: false),
                            geometrySize: containerSize,
                            showsUnreadDivider: message.id == navigation.firstUnreadID,
                            onRetryMessage: onRetryMessage,
                            chatMessageViewContainer: { msg, showName in
                                chatMessageViewContainer(
                                    in: containerSize,
                                    with: msg,
                                    with: showName,
                                    onReplyTapped: onReplyPreviewTapped != nil || msg.replyToMessageID.map { messageMetadata[$0] != nil } == true
                                        ? { navigateToReply($0, using: proxy) } : nil
                                )
                            },
                            onFirstMessageAppear: {
                                if self.reachedTop != nil && self.topReachTracker.shouldReport(message.id, isReady: hasReachedBottom && !scrollState.followsLatest) {
                                    self.reachedTop?()
                                }
                            },
                            isFirstMessage: message.id == self.messages.first?.id
                        )
                        .id(message.id)
                        .background(alignment: .bottom) {
                            if message.id == messages.last?.id {
                                Color.clear.frame(height: 1)
                                    .onGeometryChange(for: CGFloat.self) { [scrollCoordinateSpace] geometry in
                                        geometry.frame(in: .named(scrollCoordinateSpace)).maxY
                                    } action: {
                                        guard message.id == messages.last?.id else { return }
                                        bottomPosition = MessageBottomPosition(messageID: message.id, maxY: $0)
                                    }
                                    .onDisappear {
                                        if messages.last?.id == message.id, bottomPosition?.messageID == message.id {
                                            bottomPosition = nil
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding(inset)
                .scrollTargetLayout()
            }
            .coordinateSpace(name: scrollCoordinateSpace)
            .onGeometryChange(for: CGSize.self) { $0.size } action: {
                viewportBounds = CGRect(origin: .zero, size: $0)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .chatScrollTarget(scrollState.followsLatest ? messages.last?.id : nil)
            .chatScrollBehavior(followsLatest: scrollState.followsLatest) { active in
                scrollState.interactionChanged(active, isAtBottom: reachedBottomID != nil)
            }
            .overlay(alignment: .bottomTrailing) {
                if showsScrollToBottomButton, hasReachedBottom, reachedBottomID == nil, !messages.isEmpty {
                    Button { scrollToLatest(using: proxy) } label: {
                        HStack(spacing: 6) {
                            if navigation.unreadCount > 0 {
                                Text("\(navigation.unreadCount)")
                                    .monospacedDigit()
                            }
                            Image(systemName: "arrow.down")
                        }
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .tint(.primary)
                    .background(.regularMaterial, in: Capsule())
                    .accessibilityLabel(navigation.unreadCount == 0
                        ? "Scroll to latest"
                        : "\(navigation.unreadCount) unread \(navigation.unreadCount == 1 ? "message" : "messages"), scroll to latest")
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                inputView()
            }
            .onChange(of: messages.isEmpty) { _, isEmpty in
                if isEmpty {
                    hasReachedBottom = false
                    bottomPosition = nil
                    scrollState = MessageScrollState()
                }
            }
            .onChange(of: reachedBottomID) { _, reachedID in
                if let reachedID {
                    scrollState.reachedBottom()
                    hasReachedBottom = true
                    onReachedBottom?(reachedID)
                }
            }
            .onChange(of: scrollToBottom) { oldValue, newValue in
                if newValue {
                    scrollToLatest(using: proxy)
                    scrollToBottom = false
                }
            }
            .onChange(of: scrollTo) { oldValue, newValue in
                if let newValue {
                    scrollState.followsLatest = false
                    proxy.scrollTo(newValue, anchor: .top)
                    scrollTo = nil
                }
            }
        }
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
}

private extension ChatView {
    func scrollToLatest(using proxy: ScrollViewProxy) {
        guard let last = messages.last else { return }
        scrollState.followsLatest = true
        withAnimation(.easeOut(duration: 0.2)) {
            proxy.scrollTo(last.id, anchor: .bottom)
        }
    }

    func navigateToReply(_ message: Message, using proxy: ScrollViewProxy) {
        scrollState.followsLatest = false
        if let target = message.replyToMessageID, messages.contains(where: { $0.id == target }) {
            withAnimation(.easeOut(duration: 0.2)) {
                proxy.scrollTo(target, anchor: .center)
            }
        }
        onReplyPreviewTapped?(message)
    }

    // MARK: - List Item
    private func chatMessageViewContainer(
        in size: CGSize,
        with message: Message,
        with avatarShow: Bool,
        onReplyTapped: ((Message) -> Void)?
    ) -> some View {
        ChatMessageViewContainer(
            message: message,
            size: size,
            customCell: customCellView,
            onQuickReplyItemSelected: onQuickReplyItemSelected,
            contactFooterSection: contactCellFooterSection,
            onCarouselItemAction: onCarouselItemAction,
            onLinkPreviewTapped: onLinkPreviewTapped,
            onReplyPreviewTapped: onReplyTapped
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
    }
}

private extension View {
    @ViewBuilder
    func chatScrollTarget<ID: Hashable>(_ target: ID?) -> some View {
        // OS 27 reanchors growing rows with an ID binding; older versions need it for initial loading.
        if #available(iOS 27.0, macOS 27.0, *) {
            self
        } else {
            scrollPosition(id: .constant(target), anchor: .bottom)
        }
    }

    @ViewBuilder
    func chatScrollBehavior(followsLatest: Bool, onInteraction action: @escaping (Bool) -> Void) -> some View {
        if #available(iOS 18.0, macOS 15.0, *) {
            defaultScrollAnchor(.bottom, for: .initialOffset)
                .defaultScrollAnchor(.bottom, for: .alignment)
                .defaultScrollAnchor(followsLatest ? .bottom : nil, for: .sizeChanges)
                .onScrollPhaseChange { _, phase in
                    if phase == .interacting || phase == .decelerating {
                        action(true)
                    } else if phase == .idle {
                        action(false)
                    }
                }
        } else {
            defaultScrollAnchor(.bottom)
                .simultaneousGesture(DragGesture()
                    .onChanged { _ in action(true) }
                    .onEnded { _ in action(false) })
        }
    }
}

private extension ChatView {
    func shouldShowAvatarForMessage(forThisMessage: Bool) -> Bool {
        (forThisMessage || !shouldShowGroupChatHeaders)
    }
}

// MARK: - Initializers
public extension ChatView {
    /// Displays unread indicators for loaded incoming messages and enables the scroll-to-bottom button.
    func unreadMessages(_ messageIDs: Set<Message.ID>) -> Self {
        var view = self
        view.unreadMessageIDs = messageIDs
        view.showsScrollToBottomButton = true
        return view
    }

    func showsScrollToBottomButton(_ enabled: Bool = true) -> Self {
        var view = self
        view.showsScrollToBottomButton = enabled
        return view
    }

    /// Reports the newest message reached; the app decides how to persist read state.
    func onReachedBottom(_ action: @escaping (Message.ID) -> Void) -> Self {
        var view = self
        view.onReachedBottom = action
        return view
    }

    /// Called after a quote tap, including when its target needs to be loaded by the app.
    func onReplyPreviewTapped(_ action: @escaping (Message) -> Void) -> Self {
        var view = self
        view.onReplyPreviewTapped = action
        return view
    }

    /// Adds a retry action to failed outgoing messages; the app owns sending and status updates.
    func onRetryMessage(_ action: @escaping (Message) -> Void) -> Self {
        var view = self
        view.onRetryMessage = action
        return view
    }

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
    let showsUnreadDivider: Bool
    let onRetryMessage: ((Message) -> Void)?
    let chatMessageViewContainer: (Message, Bool) -> Content
    let onFirstMessageAppear: () -> Void
    let isFirstMessage: Bool
    
    var body: some View {
        VStack(alignment: message.isSender ? .trailing : .leading, spacing: 2) {
            if showsUnreadDivider {
                HStack {
                    Rectangle().frame(height: 1).accessibilityHidden(true)
                    Text("Unread messages").font(.caption.weight(.semibold))
                    Rectangle().frame(height: 1).accessibilityHidden(true)
                }
                .foregroundStyle(.secondary)
                .padding(.vertical, 8)
            }
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
                if status == .failed, let onRetryMessage {
                    Button("Retry message", systemImage: "arrow.clockwise") {
                        onRetryMessage(message)
                    }
                    .font(.caption)
                    .buttonStyle(.bordered)
                }
            }
        }
        .onAppear {
            if isFirstMessage {
                onFirstMessageAppear()
            }
        }
    }
}
