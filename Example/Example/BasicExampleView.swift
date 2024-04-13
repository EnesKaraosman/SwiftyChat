//
//  BasicExampleView.swift
//  SwiftyChatExample
//
//  Created by Enes Karaosman on 21.10.2020.
//

import SwiftUI
import SwiftyChat
import SwiftyChatMock

struct BasicExampleView: View {
    
    @State var messages: [MessageMocker.ChatMessageItem] = MessageMocker.generate(kind: .text, count: 20)
    
    @State private var message = ""
    
    var body: some View {
        chatView
    }
    
    private var chatView: some View {
        ChatView<MessageMocker.ChatMessageItem, MessageMocker.ChatUserItem>(messages: $messages) {

            BasicInputView(
                message: $message,
                placeholder: "Type something",
                onCommit: { messageKind in
                    self.messages.append(
                        .init(user: MessageMocker.sender, messageKind: messageKind, isSender: true)
                    )
                }
            )
            .background(Color.primary.colorInvert())
            .embedInAnyView()
            
        }
        // ▼ Optional, Present context menu when cell long pressed
        .messageCellContextMenu { message -> AnyView in
            switch message.messageKind {
            case .text(let text):
                return Button(action: {
                    print("Copy Context Menu tapped!!")
                    #if os(iOS)
                    UIPasteboard.general.string = text
                    #endif

                    #if os(macOS)
                    NSPasteboard.general.setString(text, forType: .string)
                    #endif
                }) {
                    Text("Copy")
                    Image(systemName: "doc.on.doc")
                }.embedInAnyView()
            default:
                // If you don't want to implement contextMenu action
                // for a specific case, simply return EmptyView like below;
                return EmptyView().embedInAnyView()
            }
        }
        // ▼ Required
        .environmentObject(ChatMessageCellStyle.basicStyle)
        #if os(iOS)
        .navigationBarTitle("Basic")
        #endif
    }
}

struct BasicExampleView_Previews: PreviewProvider {
    static var previews: some View {
        BasicExampleView()
    }
}
