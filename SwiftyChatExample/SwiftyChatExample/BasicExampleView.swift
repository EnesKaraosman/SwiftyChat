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
                let reply = Reply(fileType: .text, displayName: "Amigo Reyes", thumbnailURL: nil, fileURL: nil, text: "my sample reply", date: "Feb 15, 2023, 6:05 PM")
//                let replies = [Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text: "my 1", date: "Feb 15, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 2", thumbnailURL: nil, fileURL: nil, text: "my 2", date: "Feb 10, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 3", thumbnailURL: nil, fileURL: nil, text: "my 3", date: "Feb 12, 2023, 6:05 PM")]
//                let replies = [Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  Lorem.paragraphs(nbParagraphs: 5), date: "Feb 15, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text: Lorem.paragraphs(nbParagraphs: 5), date: "Feb 15, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  Lorem.paragraphs(nbParagraphs: 5), date: "Feb 15, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  "hello", date: "Feb 15, 2023, 6:05 PM")]
                
                let replies = [Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  "hello", date: "Feb 15, 2023, 6:05 PM")]
                let repliesImage = [Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  "1", date: "Feb 15, 2023, 6:05 PM"),
                                    Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  "2", date: "Feb 15, 2023, 6:05 PM"),
                                    Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  "3", date: "Feb 15, 2023, 6:05 PM"),
                                    Reply(fileType: .image, displayName: "Amigo 1", thumbnailURL: "https://medchat.s3.amazonaws.com/c5f0fac8-8745-44ac-8e37-72db62c775a8Screenshot%202023-02-21%20at%204.54.01%20PM.png", fileURL: "https://medchat.s3.amazonaws.com/c5f0fac8-8745-44ac-8e37-72db62c775a8Screenshot%202023-02-21%20at%204.54.01%20PM.png", text:  nil, date: "Feb 15, 2023, 6:05 PM")]
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .reply(reply, replies),
                                           messageUUID: UUID().uuidString))
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .reply(reply, repliesImage),isSender: true,
                                           messageUUID: UUID().uuidString))
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .reply(reply, replies),isSender: true,status: .sending,
                                           messageUUID: UUID().uuidString))
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .reply(reply, replies),isSender: true,status: .failed,
                                           messageUUID: UUID().uuidString))
                let placeHolder = ImageLoadingKind.local (UIImage(systemName: "video")!)
                let videItem = TestVideo(url: URL(string: "https://medchat.s3.amazonaws.com/0ad14146-690c-4a92-9341-b8fd5b226b1bD67F6B53-12E3-4AA9-9EF7-3991D33D914E.mov")!, placeholderImage: placeHolder, pictureInPicturePlayingMessage: "Video")
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .video(videItem),isSender: true,status: .sent,
                                           messageUUID: UUID().uuidString))
                
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .audio(URL(string: "https://medchat.s3.amazonaws.com/7a865af9-1dc8-46e7-baa8-61a64d3b48fdrecorded-audio.mp3")!),isSender: true,status: .sent,
                                           messageUUID: UUID().uuidString))
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .audio(URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!),isSender: false,status: .sent,
                                           messageUUID: UUID().uuidString))

                

                
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
        }
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
