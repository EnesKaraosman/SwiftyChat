//
//  AdvancedExampleView.swift
//  SwiftyChatExample
//
//  Created by Enes Karaosman on 20.10.2020.
//

import SwiftUI
import SwiftyChat

fileprivate let html1 = """
<ul>
  <li>Domates</li>
  <li>Biber</li>
  <li>Patlıcan</li>
  <li>Patates</li>
  <li>Tea</li>
  <li>Milk</li>
  <li>123</li>
  <li>456</li>
</ul>
"""

fileprivate let htmlLink = """
<a href="https://www.w3schools.com">Visit W3Schools.com!</a>
"""

struct AdvancedExampleView: View {
    
    @State var messages: [MockMessages.ChatMessageItem] = []
    @State private var scrollToBottom = false
    
    @State private var message = ""
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            chatView
        }
    }
    
    private var chatView: some View {

        ChatView<MockMessages.ChatMessageItem, MockMessages.ChatUserItem>(inverted: true, messages: $messages) {

            BasicInputView(
                message: $message,
                isEditing: $isEditing,
                placeholder: "Type something",
                onCommit: { messageKind in
                    self.messages.append(
                        .init(user: MockMessages.sender, messageKind: messageKind, isSender: true)
                    )
                }
            )
            .padding(8)
            .padding(.bottom, isEditing ? 0 : 8)
            .background(Color.primary.colorInvert())
            .embedInAnyView()
            
        }
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
                MockMessages.ChatMessageItem(
                    user: MockMessages.sender,
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
        // ▼ Optional, Implement to be notified when related attributed text typed
        // like address, date, phoneNumber, url
        .onAttributedTextTappedCallback {
            AttributedTextTappedCallback(
                didSelectDate: { print($0) },
                didSelectPhoneNumber: { print($0) },
                didSelectURL: { print($0) }
            )
        }
        // ▼ Optional
        .onCarouselItemAction(action: { (button, message) in
            print(message.messageKind.description)
        })
        // ▼ Required
        .environmentObject(ChatMessageCellStyle())
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .listStyle(PlainListStyle())
        .onAppear {
   
            if let portraitUrl = URL(string: "https://picsum.photos/200/300") {
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .image(.remote(portraitUrl))))
            }

            if let landscapeUrl = URL(string:"https://picsum.photos/400/200") {
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .image(.remote(landscapeUrl))))
            }

            
            self.messages.append(
                .init(
                    user: MockMessages.chatbot,
                    messageKind: .text("https://github.com/EnesKaraosman/SwiftyChat and here is his phone +90 537 844 11-41, & mail: eneskaraosman53@gmail.com Today is 27 May 2020")
                )
            )
            
            self.messages.append(contentsOf: MockMessages.generatedMessages(count: 100))
           // self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text(html1), isSender: false))
           // self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text(htmlLink), isSender: false))
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedExampleView()
    }
}
