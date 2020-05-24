//
//  ChatView.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public struct ChatView: View {
    
    @Binding public var messages: [ChatMessage]
    public var onCellTapped: (ChatMessage) -> Void
    public var onCellContextMenu: (ChatMessage) -> AnyView = { _ in EmptyView().embedInAnyView() }
    public var onQuickReplyItemSelected: (QuickReply) -> Void = { _ in }
    public var inputView: (_ proxy: GeometryProxy) -> AnyView
    
    public init(
        messages: Binding<[ChatMessage]>,
        onCellTapped: @escaping (ChatMessage) -> Void = { _ in },
        onCellContextMenu: @escaping (ChatMessage) -> AnyView = { _ in EmptyView().embedInAnyView() },
        inputView: @escaping (_ proxy: GeometryProxy) -> AnyView
    ) {
        self._messages = messages
        self.onCellTapped = onCellTapped
        self.onCellContextMenu = onCellContextMenu
        self.inputView = inputView
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                
                List {
                    ForEach(self.messages) { message in
                        ChatMessageCellContainer(message: message, proxy: proxy, onQuickReplyItemSelected: self.onQuickReplyItemSelected)
                            .onTapGesture {
                                self.onCellTapped(message)
                            }
                            .contextMenu(menuItems: {
                                self.onCellContextMenu(message)
                            })
                            .modifier(MessageModifier(isSender: message.isSender))
                    }
                }
                .padding(.bottom, proxy.safeAreaInsets.bottom + 56)
                
                self.inputView(proxy)
                
            }.keyboardAwarePadding()
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
            // To remove all separators including the actual ones:
            UITableView.appearance().separatorStyle = .none
        }
    }
}
