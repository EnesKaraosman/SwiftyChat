//
//  BasicExampleView.swift
//  SwiftyChatExample
//
//  Created by Enes Karaosman on 21.10.2020.
//

import SwiftUI
import SwiftyChat

public struct Reply : ReplyItem {
    public var id: UUID = UUID()
    public var fileType: ReplyItemKind
    public var displayName: String
    public var thumbnailURL: String?
    public var fileURL: String?
    public var text: String?
    public var date: String
    
    init(fileType : ReplyItemKind,displayName : String,thumbnailURL : String?,fileURL: String?, text :String?, date: String ){
        self.fileURL = fileURL
        self.fileType = fileType
        self.displayName = displayName
        self.thumbnailURL = thumbnailURL
        self.fileURL = fileURL
        self.text = text
        self.date = date
    }
    
}
struct BasicExampleView: View {
    
    @State var messages: [MockMessages.ChatMessageItem] = MockMessages.generateMessage(kind: .Text, count: 10)
    
    // MARK: - InputBarView variables
    @State private var message = ""
    @State private var isEditing = false
    var body: some View {
        chatView
            .onAppear {
                let reply = Reply(fileType: .text, displayName: "Amigo Reyes", thumbnailURL: nil, fileURL: nil, text: "my sample reply", date: "Feb 15, 2023, 6:05 PM")
//                let replies = [Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text: "my 1", date: "Feb 15, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 2", thumbnailURL: nil, fileURL: nil, text: "my 2", date: "Feb 10, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 3", thumbnailURL: nil, fileURL: nil, text: "my 3", date: "Feb 12, 2023, 6:05 PM")]
//                let replies = [Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  Lorem.paragraphs(nbParagraphs: 5), date: "Feb 15, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text: Lorem.paragraphs(nbParagraphs: 5), date: "Feb 15, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  Lorem.paragraphs(nbParagraphs: 5), date: "Feb 15, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  "hello", date: "Feb 15, 2023, 6:05 PM")]
                
                let replies = [Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  "hello", date: "Feb 15, 2023, 6:05 PM")]
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .reply(reply, replies)))
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .reply(reply, replies),isSender: true))

            }
    }
    
    private var chatView: some View {
        
        ChatView<MockMessages.ChatMessageItem, MockMessages.ChatUserItem>(inverted : true , messages: $messages) {

            BasicInputView(
                message: $message,
                isEditing: $isEditing,
                placeholder: "Type something",
                onCommit: { messageKind in
                    self.messages.append(
                        .init(user: MockMessages.chatbot, messageKind: messageKind, isSender: true)
                    )
                }
            )
            .padding(8)
            .padding(.bottom, isEditing ? 0 : 8)
            .accentColor(.chatBlue)
            .background(Color.primary.colorInvert())
            .animation(.linear)
            .embedInAnyView()
            
        }
        // ▼ Optional, Present context menu when cell long pressed
        .messageCellContextMenu { message -> AnyView in
            switch message.messageKind {
            case .text(let text,_):
                return Button(action: {
                    print("Copy Context Menu tapped!!")
                    UIPasteboard.general.string = text
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
        .navigationBarTitle("Basic")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(PlainListStyle())
    }
}

struct BasicExampleView_Previews: PreviewProvider {
    static var previews: some View {
        BasicExampleView()
    }
}
