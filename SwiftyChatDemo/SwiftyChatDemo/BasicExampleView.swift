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

    @State private var messages: [MessageMocker.ChatMessageItem] = []
    @State private var message = ""
    @State private var olderPagesRemaining = 3

    var body: some View {
        chatView
            .task {
                if messages.isEmpty {
                    messages = MessageMocker.generate(kind: .text, count: 20)
                }
            }
    }

    private var chatView: some View {
        ChatView(messages: $messages, inputView: {
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
        }, reachedTop: loadOlder)
        .messageCellContextMenu { message in
            switch message.messageKind {
            case .text(let text):
                Button(
                    action: {
                        print("Copy Context Menu tapped!!")
                        #if os(iOS)
                        UIPasteboard.general.string = text
                        #endif
                        #if os(macOS)
                        NSPasteboard.general.setString(text, forType: .string)
                        #endif
                    },
                    label: {
                        Text("Copy")
                        Image(systemName: "doc.on.doc")
                    }
                )
            default:
                EmptyView()
            }
        }
        // ▼ Required
        .environment(\.chatStyle, ChatMessageCellStyle.basicStyle)
        #if os(iOS)
        .navigationBarTitle("Basic")
        #endif
    }

    private func loadOlder() {
        guard olderPagesRemaining > 0, let oldestDate = messages.first?.date else { return }
        let page = olderPagesRemaining
        olderPagesRemaining -= 1
        let olderMessages = (0..<10).map { index in
            MessageMocker.ChatMessageItem(
                user: MessageMocker.chatbot,
                messageKind: .text("Earlier page \(page), message \(index + 1)"),
                date: oldestDate.addingTimeInterval(TimeInterval(index - 10) * 60)
            )
        }
        messages.insert(contentsOf: olderMessages, at: 0)
    }
}

struct BasicExampleView_Previews: PreviewProvider {
    static var previews: some View {
        BasicExampleView()
    }
}
