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
                
//                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .imageText(.remote(URL(string: "https://picsum.photos/200/300")!), """
//                                                                                          The standard Lorem Ipsum passage, used since the 1500s
//                                                                                          \"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\"
//
//                                                                                          Section 1.10.32 of \"de Finibus Bonorum et Malorum\", written by Cicero in 45 BC
//                                                                                          \"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam
//                                                                                          
//                                                                                          """, ["Jett Calleja"], .high, .pending), messageUUID: UUID().uuidString))

                
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text(
                """
                <p>Hello world amazing normal message <strong>BOLD </strong>space <strong><em>Italic</em></strong></p>
                <ul>
                    <li><strong>Bullet 1</strong></li>
                    <li><em>Bullet 2 with italic</em></li>
                </ul>
                <ol>
                    <li><u>Numbered item 1 with underline</u></li>
                    <li>Numbered item 2</li>
                </ol>
                """.trimmingCharacters(in: .whitespacesAndNewlines)
                , nil, .routine, .none), messageUUID: UUID().uuidString))
                
                
                
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("<p>Hello world amazing normal message <strong>BOLD </strong>space <strong><em>Italic</em></strong><s> strike testing</s></p>", nil, .routine, .none), messageUUID: UUID().uuidString))

                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text(
                """
<p dir="ltr"><span style="color:#2196F3;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b>@Kristopher Amiel</b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b> </b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b>T</b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b>e</b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b>s</b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b>t</b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b> </b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b>b</b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b>o</b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b>l</b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b>d</b></span></b></span></b></span></b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b> </b></span></b></span></b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b>t</b></span></b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b>e</b></span></b></span></b></span></b></span></b></span><span style="font-size:1.00em;"><b><span style="font-size:1.00em;"><b>x</b></span></b></span><span style="font-size:1.00em;"><b>t</b></span></p>
""", nil, .routine, .none), messageUUID: UUID().uuidString))
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
            
        }reachedTop: { lastDate in
            print("Top cell \(lastDate)")
        }reachedBottom: { lastDate in
            print("Bottom cell \(lastDate)")
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
