//
//  ChatView.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public struct ChatView<Message: ChatMessage, User: ChatUser>: View {
    
    @Binding private var messages: [Message]
    private var inputView: (_ proxy: GeometryProxy) -> AnyView

    private var onMessageCellTapped: (Message) -> Void = { msg in print(msg.messageKind) }
    private var messageCellContextMenu: (Message) -> AnyView = { _ in EmptyView().embedInAnyView() }
    private var onQuickReplyItemSelected: (QuickReplyItem) -> Void = { _ in }
    private var contactCellFooterSection: (ContactItem, Message) -> [ContactCellButton] = { _, _ in [] }
    private var onAttributedTextTappedCallback: () -> AttributedTextTappedCallback = { return AttributedTextTappedCallback() }
    private var onCarouselItemAction: (CarouselItemButton, Message) -> Void = { (_, _) in }
    
    public init(
        messages: Binding<[Message]>,
        inputView: @escaping (_ proxy: GeometryProxy) -> AnyView
    ) {
        self._messages = messages
        self.inputView = inputView
    }
    
    public var body: some View {
        DeviceOrientationBasedView(
            portrait: { GeometryReader { body(in: $0) } },
            landscape: { GeometryReader { body(in: $0) } }
        )
        .environmentObject(OrientationInfo())
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // MARK: - Body in geometry
    private func body(in geometry: GeometryProxy) -> some View {
        ZStack(alignment: .bottom) {
                    
            if #available(iOS 14.0, *) {
                iOS14Body(in: geometry)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 56)
            } else {
                iOS14Fallback(in: geometry)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 56)
            }

            inputView(geometry)

        }
        .keyboardAwarePadding()
        .dismissKeyboardOnTappingOutside()
    }
    
    @available(iOS 14.0, *)
    private func iOS14Body(in geometry: GeometryProxy) -> some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVStack {
                    ForEach(messages) { message in
                        chatMessageCellContainer(in: geometry.size, with: message)
                    }
                }
            }
        }
        .background(Color.clear)
    }
    
    private func iOS14Fallback(in geometry: GeometryProxy) -> some View {
        List(messages) { message in
            chatMessageCellContainer(in: geometry.size, with: message)
        }
        .onAppear {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
            // To remove all separators including the actual ones:
            UITableView.appearance().separatorStyle = .none
            
            // To clear background colors to allow library user set himself
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        }
    }
    
    // MARK: - List Item
    private func chatMessageCellContainer(in size: CGSize, with message: Message) -> some View {
        ChatMessageCellContainer(
            message: message,
            size: size,
            onQuickReplyItemSelected: onQuickReplyItemSelected,
            contactFooterSection: contactCellFooterSection,
            onTextTappedCallback: onAttributedTextTappedCallback,
            onCarouselItemAction: onCarouselItemAction
        )
        .onTapGesture { onMessageCellTapped(message) }
        .contextMenu(menuItems: { messageCellContextMenu(message) })
        .modifier(AvatarModifier<Message, User>(message: message))
        .modifier(MessageHorizontalSpaceModifier(messageKind: message.messageKind, isSender: message.isSender))
        .modifier(CellEdgeInsetsModifier(isSender: message.isSender))
    }
    
}

public extension ChatView {
    
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
    
    /// To listen text tapped events like phone, url, date, address
    func onAttributedTextTappedCallback(action: @escaping () -> AttributedTextTappedCallback) -> Self {
        then({ $0.onAttributedTextTappedCallback = action })
    }
    
    /// Triggered when the carousel button tapped.
    func onCarouselItemAction(action: @escaping (CarouselItemButton, Message) -> Void) -> Self {
        then({ $0.onCarouselItemAction = action })
    }
    
}
