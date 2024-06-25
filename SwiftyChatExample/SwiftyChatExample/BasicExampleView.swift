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
    
    @State var messages: [MockMessages.ChatMessageItem] = MockMessages.generateMessage(kind: .Text, count: 1)
    
    // MARK: - InputBarView variables
    @State private var message = ""
    @State private var isEditing = false
    @State private var showingOptions = false

    var body: some View {
        chatView
            .onAppear {
//                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("Amigo Reyes", nil, .attention, nil), messageUUID: UUID().uuidString))
//                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("New task(s) are assigned to you on action items. \n Note: Operation Singil: si ocs", ["Jett Calleja"], .attention, .pending), messageUUID: UUID().uuidString))
//                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("New task(s) are assigned to you on action items. \n Note: Operation Singil: si ocs", ["Jett Calleja"], .medium, .pending), messageUUID: UUID().uuidString))
//                
//                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("New task(s) are assigned to you on action items. \n Note: Operation Singil: si ocs", ["Jett Calleja"], .high, .pending), messageUUID: UUID().uuidString))
//                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("New task(s) are assigned to you on action items. \n Note: Operation Singil: si ocs", ["Jett Calleja"], .high, .pending), messageUUID: UUID().uuidString))
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
                        .init(user: MockMessages.chatbot, messageKind: messageKind, isSender: true,
                              messageUUID: UUID().uuidString)
                    )
                }
            )
            .padding(8)
            .padding(.bottom, isEditing ? 0 : 8)
            .accentColor(.chatBlue)
            .background(Color.primary.colorInvert())
            .animation(.linear)
            .embedInAnyView()
            
        }tappedResendAction: { message in
            print("resend tapped message ",message.messageKind.description)
        
        }didDismissKeyboard: {
            
        }
        .didTappedViewTask({ message in
            print("didtapped view task \(message.messageKind)")
        })
        .onMessageCellLongpressed({ message in
            print(  message.messageKind.description)
            self.showingOptions = true
        })
            
        
        .actionSheet(isPresented: $showingOptions) {
            ActionSheet(
                title: Text("Food alert!"),
                message: Text("You have made a selection"),
                buttons: [
                    .cancel(),
                    .destructive(Text("Change to 🍑")) { /* override */ },
                    .default(Text("Confirm")) { /* confirm */ }
                ]
            )
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
struct TestVideo: VideoItem {
    var url: URL
    var placeholderImage: ImageLoadingKind
    var pictureInPicturePlayingMessage: String
}
