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
        ChatView(
            messages: $messages,
            scrollToBottom: $scrollToBottom
        ) {
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
        }
        .registerCustomCell { anyParam in
            CustomExampleChatCell(anyParam: anyParam)
        }
        .onMessageCellTapped({ (message) in
            print(message.messageKind.description)
        })
        .messageCellContextMenu { message in
            switch message.messageKind {
            case .text:
                Button(
                    action: {
                        print("Forward Context Menu tapped!!")
                    },
                    label: {
                        Text("Forward")
                        Image(systemName: "arrowshape.turn.up.right")
                    }
                )
            default:
                EmptyView()
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
        .contactItemButtons { (contact, _) -> [ContactCellButton] in
            return [
                .init(title: "Save", action: {
                    print(contact.displayName)
                })
            ]
        }
        // ▼ Optional
        .onCarouselItemAction(action: { (_, message) in
            print(message.messageKind.description)
        })
        // ▼ Required
        .environment(\.chatStyle, ChatMessageCellStyle())
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

            self.messages.append(contentsOf: MessageMocker.generate(count: 93))
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
