//
//  ChatView.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public struct ChatView: View {
    
    let localUser: ChatUser
    @Binding public var messages: [ChatMessage]
    @Binding public var typingUser: ChatUser?
    @Binding public var scrollIndex: Int?
    public var inputView: (_ proxy: GeometryProxy) -> AnyView
    
    
    //iOS 13 scroll hacks
    @State private var scrollManager = ScrollManager()
    @State private var lastMessage: ChatMessage?
    @State private var indexPathToSetVisible: IndexPath?
    @State private var wasTyping: Bool = false
    
    private var onMessageCellTapped: (ChatMessage) -> Void = { msg in print(msg.messageKind) }
    private var messageCellContextMenu: (ChatMessage) -> AnyView = { _ in EmptyView().embedInAnyView() }
    private var onQuickReplyItemSelected: (QuickReplyItem) -> Void = { _ in }
    private var contactCellFooterSection: (ContactItem, ChatMessage) -> [ContactCellButton] = { _, _ in [] }
    private var onAttributedTextTappedCallback: () -> AttributedTextTappedCallback = { return AttributedTextTappedCallback() }
    private var onCarouselItemAction: (CarouselItemButton, ChatMessage) -> Void = { (_, _) in }
    
    public init(
        localUser: ChatUser,
        messages: Binding<[ChatMessage]>,
        typingUser: Binding<ChatUser?>,
        scrollIndex: Binding<Int?> = .constant(nil),
        inputView: @escaping (_ proxy: GeometryProxy) -> AnyView
    ) {
        self.localUser = localUser
        self._messages = messages
        self._typingUser = typingUser
        self._scrollIndex = scrollIndex
        self.inputView = inputView
    }
    
    /// Triggered when a ChatMessage is tapped.
    public func onMessageCellTapped(_ action: @escaping (ChatMessage) -> Void) -> ChatView {
        var copy = self
        copy.onMessageCellTapped = action
        return copy
    }
    
    /// Present ContextMenu when a message cell is long pressed.
    public func messageCellContextMenu(_ action: @escaping (ChatMessage) -> AnyView) -> ChatView {
        var copy = self
        copy.messageCellContextMenu = action
        return copy
    }
    
    /// Triggered when a quickReplyItem is selected (ChatMessageKind.quickReply)
    public func onQuickReplyItemSelected(_ action: @escaping (QuickReplyItem) -> Void) -> ChatView {
        var copy = self
        copy.onQuickReplyItemSelected = action
        return copy
    }
    
    /// Present contactItem's footer buttons. (ChatMessageKind.contactItem)
    public func contactItemButtons(_ section: @escaping (ContactItem, ChatMessage) -> [ContactCellButton]) -> ChatView {
        var copy = self
        copy.contactCellFooterSection = section
        return copy
    }
    
    /// To listen text tapped events like phone, url, date, address
    public func onAttributedTextTappedCallback(action: @escaping () -> AttributedTextTappedCallback) -> ChatView {
        var copy = self
        copy.onAttributedTextTappedCallback = action
        return copy
    }
    
    /// Triggered when the carousel button tapped.
    public func onCarouselItemAction(action: @escaping (CarouselItemButton, ChatMessage) -> Void) -> ChatView {
        var copy = self
        copy.onCarouselItemAction = action
        return copy
    }
    
    var tableViewFinderOverlay: AnyView {
        // we only need to add one overlay view to find the parent table view, we don't want an overlay view on each row
        if scrollManager.tableView == nil {
            return AnyView(TableViewFinder(scrollManager: scrollManager))
        }
        return AnyView(EmptyView())
    }
    
    public var body: some View {
        DeviceOrientationBasedView(
            portrait: { GeometryReader { self.body(in: $0) } },
            landscape: { GeometryReader { self.body(in: $0) } }
        )
        .environmentObject(OrientationInfo())
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
            // To remove all separators including the actual ones:
            UITableView.appearance().separatorStyle = .none
        }
    }
    
    // MARK: - Body in geometry
    private func body(in geometry: GeometryProxy) -> some View {
        ZStack(alignment: .bottom) {
            messagesView(geometry: geometry)
            self.inputView(geometry)
        }.keyboardAwarePadding()
    }
    
    private func messagesView(geometry: GeometryProxy) -> some View {
        if #available(iOS 14.0, *) {
            return ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(messages.indices, id: \.self) { index in
                            VStack {
                                self.chatMessageCellContainer(in: geometry.size, with: messages[index])
                                typingView(for: index)
                            }
                            .id(index)
                        }.onChange(of: scrollIndex) { index in
                            scrollToIndex(index, with: proxy)
                        }
                        .onChange(of: messages) { _ in
                            scrollToBottom(with: proxy)
                        }
                        .onChange(of: typingUser) { _ in
                            scrollToBottom(with: proxy)
                        }
                    }
                }
            }
            .padding()
            .embedInAnyView()
        } else {
            return List(messages.indices, id: \.self) { index in
                VStack {
                    self.chatMessageCellContainer(in: geometry.size, with: messages[index])
                        .overlay(
                            // we need this to grab the reference to the table view that we want to programmatically scroll
                            // the only way to add a child view to a List is to either add it to one of the rows or to insert an extra row
                            self.tableViewFinderOverlay
                                .frame(width: 0, height: 0)
                        )
                        .listRowBackground(Color.black)
                    typingView(for: index)
                }
            }
            .background(
                // the scrolling has to be done via the binding `indexPathToSetVisible`
                ScrollManagerView(
                    scrollManager: scrollManager,
                    indexPathToSetVisible: $indexPathToSetVisible
                )
            )
            .overlay(Group { () -> EmptyView in
                guard let currentLastMessage = messages.last else { return EmptyView() }
                let endIndexPath = IndexPath(row: max(0, messages.count - 1), section: 0)
                guard currentLastMessage != self.lastMessage ||
                        (typingUser != nil && !wasTyping)
                else { return EmptyView() }
                
                DispatchQueue.main.async {
                    self.lastMessage = currentLastMessage
                    self.indexPathToSetVisible = endIndexPath
                    self.wasTyping = typingUser != nil
                }
                return EmptyView()
            })
            
            .embedInAnyView()
        }
    }
    
    @ViewBuilder
    private func typingView(for index: Int) -> some View {
        if let typingUser = typingUser, index == messages.index(before: messages.endIndex) {
            TypingMessageView(isSender: typingUser != localUser, user: typingUser)
        } else {
            EmptyView()
        }
    }
    
    // MARK: - List Item
    private func chatMessageCellContainer(in size: CGSize, with message: ChatMessage) -> some View {
        ChatMessageCellContainer(
            message: message,
            size: size,
            onQuickReplyItemSelected: self.onQuickReplyItemSelected,
            contactFooterSection: self.contactCellFooterSection,
            onTextTappedCallback: self.onAttributedTextTappedCallback,
            onCarouselItemAction: self.onCarouselItemAction
        )
        .id(message.id)
        .onTapGesture {
            self.onMessageCellTapped(message)
        }
        .contextMenu(menuItems: {
            self.messageCellContextMenu(message)
        })
        .modifier(AvatarModifier(message: message))
        .modifier(MessageModifier(messageKind: message.messageKind, isSender: message.isSender))
        .modifier(CellEdgeInsetsModifier(isSender: message.isSender))
        .animation(nil)
    }
    
    @available(iOS 14.0, *)
    private func scrollToBottom(with proxy: ScrollViewProxy) {
        withAnimation { scrollToIndex(messages.indices.last, with: proxy) }
    }
    
    @available(iOS 14.0, *)
    private func scrollToIndex(_ index: Int?, with proxy: ScrollViewProxy) {
        withAnimation { proxy.scrollTo(index) }
    }
}
