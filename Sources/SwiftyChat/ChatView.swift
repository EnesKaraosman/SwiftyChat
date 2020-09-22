//
//  ChatView.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public struct ChatView: View {

    let autoScroll: Bool
    @State var lastMessage: ChatMessage?
    @State var indexPathToSetVisible: IndexPath?
    @Binding public var messages: [ChatMessage]
    public var inputView: (_ proxy: GeometryProxy) -> AnyView

    private var onMessageCellTapped: (ChatMessage) -> Void = { msg in print(msg.messageKind) }
    private var messageCellContextMenu: (ChatMessage) -> AnyView = { _ in EmptyView().embedInAnyView() }
    private var onQuickReplyItemSelected: (QuickReplyItem) -> Void = { _ in }
    private var contactCellFooterSection: (ContactItem, ChatMessage) -> [ContactCellButton] = { _, _ in [] }
    private var onAttributedTextTappedCallback: () -> AttributedTextTappedCallback = { return AttributedTextTappedCallback() }
    private var onCarouselItemAction: (CarouselItemButton, ChatMessage) -> Void = { (_, _) in }
    
    public init(
        messages: Binding<[ChatMessage]>,
        inputView: @escaping (_ proxy: GeometryProxy) -> AnyView,
        autoScroll: Bool = true
    ) {
        self._messages = messages
        self.inputView = inputView
        self.autoScroll = autoScroll
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
    
    struct BindingView: View {
        @Binding var messages: [ChatMessage]
        
        var body: some View {
            return EmptyView()
        }
    }
    
    // MARK: - Body in geometry
    private func body(in geometry: GeometryProxy) -> some View {
        ZStack(alignment: .bottom) {
            List(messages) { message in
                self.chatMessageCellContainer(in: geometry.size, with: message)
                    .listRowBackground(Color.black)
                    .rotationEffect(.radians(.pi))
                    .scaleEffect(x: -1, y: 1, anchor: .center)
            }
            .padding(.bottom, geometry.safeAreaInsets.bottom + 56)
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)

            self.inputView(geometry)

        }.keyboardAwarePadding()
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
    }
    
}
