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
    @State private var streamTask: Task<Void, Never>?
    @State private var isStreaming = false

    var body: some View {
        chatView
            .task {
                if messages.isEmpty {
                    messages = MessageMocker.generate(kind: .text, count: 20)
                }
            }
            .onDisappear {
                streamTask?.cancel()
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
        .toolbar {
            Button(isStreaming ? "Stop stream" : "Stream reply") {
                if isStreaming {
                    streamTask?.cancel()
                } else {
                    startStreaming()
                }
            }
        }
    }

    private func startStreaming() {
        let reply = "SwiftyChat can update a single message as a chatbot response arrives. Scroll up while this text grows to check that reading history stays comfortable."
        let streamedMessage = MessageMocker.ChatMessageItem(
            user: MessageMocker.chatbot,
            messageKind: .text("")
        )
        messages.append(streamedMessage)
        isStreaming = true
        streamTask = Task { @MainActor in
            var text = ""
            for word in reply.split(separator: " ") {
                guard !Task.isCancelled else { break }
                text += text.isEmpty ? String(word) : " \(word)"
                if let index = messages.firstIndex(where: { $0.id == streamedMessage.id }) {
                    messages[index].messageKind = .text(text)
                }
                try? await Task.sleep(for: .milliseconds(80))
            }
            isStreaming = false
            streamTask = nil
        }
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
