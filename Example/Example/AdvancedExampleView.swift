//
//  AdvancedExampleView.swift
//  SwiftyChatExample
//
//  Created by Enes Karaosman on 20.10.2020.
//

import SwiftUI
import SwiftyChat
import SwiftyChatMock

struct AdvancedExampleView: View {

    @State var messages: [MessageMocker.ChatMessageItem] = []
    @State private var scrollToBottom = false

    @State private var message = ""

    var body: some View {
        chatView
    }

    private var chatView: some View {
        ChatView<MessageMocker.ChatMessageItem, MessageMocker.ChatUserItem>(messages: $messages, scrollToBottom: $scrollToBottom) {
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
        // ▼ Optional, Implement to register a custom cell for Messagekind.custom
        .registerCustomCell(customCell: { anyParam in AnyView(CustomExampleChatCell(anyParam: anyParam))})
        // ▼ Optional, Implement to be notified when related cell tapped
        .onMessageCellTapped({ (message) in
            print(message.messageKind.description)
        })
        // ▼ Optional, Present context menu when cell long pressed
        .messageCellContextMenu { message -> AnyView in
            switch message.messageKind {
            case .text:
                return Button(action: {
                    print("Forward Context Menu tapped!!")
                    // Forward text
                }) {
                    Text("Forward")
                    Image(systemName: "arrowshape.turn.up.right")
                }.embedInAnyView()
            default:
                // If you don't want to implement contextMenu action
                // for a specific case, simply return EmptyView like below;
                return EmptyView().embedInAnyView()
            }
        }
        // ▼ Implement in case ChatMessageKind.quickReply
        .onQuickReplyItemSelected { (quickReply) in
            self.messages.append(
                MessageMocker.ChatMessageItem(
                    user: MessageMocker.sender,
                    messageKind: .text(quickReply.title),
                    isSender: true
                )
            )
        }
        // ▼ Implement in case ChatMessageKind.contact
        .contactItemButtons { (contact, message) -> [ContactCellButton] in
            return [
                .init(title: "Save", action: {
                    print(contact.displayName)
                })
            ]
        }
        // ▼ Optional
        .onCarouselItemAction(action: { (button, message) in
            print(message.messageKind.description)
        })
        // ▼ Required
        .environmentObject(ChatMessageCellStyle())
        #if os(iOS)
        .navigationBarTitle("Advanced")
        #endif
        .task {
            if let portraitUrl = URL(string: "https://picsum.photos/id/\(Int.random(in: 1...100))/400/600") {
                self.messages.append(.init(user: MessageMocker.chatbot, messageKind: .image(.remote(portraitUrl))))
            }

            self.messages.append(
                .init(
                    user: MessageMocker.chatbot,
                    messageKind: .text("https://github.com/EnesKaraosman/SwiftyChat and here is his phone +90 537 844 11-41, & mail: eneskaraosman53@gmail.com Today is 27 May 2020")
                )
            )

            self.messages.append(contentsOf: MessageMocker.generated(count: 53))
        }
    }
}

struct CustomExampleChatCell: View {
    var anyParam: Any

    var body: some View {
        Text((anyParam as? String) ?? "Not a String")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .cornerRadius(24)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedExampleView()
    }
}
