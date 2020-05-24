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
    public var onCellTapped: (ChatMessage) -> Void = { _ in }
    public var onCellContextMenu: (ChatMessage) -> AnyView = { _ in EmptyView().embedInAnyView() }
    public var onQuickReplyItemSelected: (QuickReply) -> Void = { _ in }
    public var inputView: (_ proxy: GeometryProxy) -> AnyView
    
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
        .navigationBarTitle("Swifty Chatbot", displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
            // To remove all separators including the actual ones:
            UITableView.appearance().separatorStyle = .none
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    @State static var messages = MockMessages.messages
    static var previews: some View {
        ChatView(messages: $messages) { proxy in
            InputView(proxy: proxy) { (messageKind) in
                messages.append(
                    ChatMessage(
                        user: MockMessages.sender,
                        messageKind: messageKind,
                        isSender: true
                    )
                )
            }.embedInAnyView()
        }
    }
}
