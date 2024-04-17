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
//                let reply = Reply(fileType: .text, displayName: "Amigo Reyes", thumbnailURL: nil, fileURL: nil, text: "my sample reply", date: "Feb 15, 2023, 6:05 PM")
//                let replies = [Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text: "my 1", date: "Feb 15, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 2", thumbnailURL: nil, fileURL: nil, text: "my 2", date: "Feb 10, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 3", thumbnailURL: nil, fileURL: nil, text: "my 3", date: "Feb 12, 2023, 6:05 PM")]
//                let replies = [Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  Lorem.paragraphs(nbParagraphs: 5), date: "Feb 15, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text: Lorem.paragraphs(nbParagraphs: 5), date: "Feb 15, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  Lorem.paragraphs(nbParagraphs: 5), date: "Feb 15, 2023, 6:05 PM"),
//                               Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  "hello", date: "Feb 15, 2023, 6:05 PM")]
//                
//                let replies = [Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  "hello", date: "Feb 15, 2023, 6:05 PM")]
//                let repliesImage = [Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  "1", date: "Feb 15, 2023, 6:05 PM"),
//                                    Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  "2", date: "Feb 15, 2023, 6:05 PM"),
//                                    Reply(fileType: .text, displayName: "Amigo 1", thumbnailURL: nil, fileURL: nil, text:  "3", date: "Feb 15, 2023, 6:05 PM"),
//                                    Reply(fileType: .image, displayName: "Amigo 1", thumbnailURL: "https://medchat.s3.amazonaws.com/c5f0fac8-8745-44ac-8e37-72db62c775a8Screenshot%202023-02-21%20at%204.54.01%20PM.png", fileURL: "https://medchat.s3.amazonaws.com/c5f0fac8-8745-44ac-8e37-72db62c775a8Screenshot%202023-02-21%20at%204.54.01%20PM.png", text:  nil, date: "Feb 15, 2023, 6:05 PM")]
//                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .reply(reply, replies, MessagePriorityLevel(rawValue: -1)!),
//                                           messageUUID: UUID().uuidString))
//                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .reply(reply, repliesImage, MessagePriorityLevel(rawValue: -1)!),isSender: true,
//                                           messageUUID: UUID().uuidString))
//                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .reply(reply, replies, MessagePriorityLevel(rawValue: -1)!),isSender: true,status: .sending,
//                                           messageUUID: UUID().uuidString))
                let placeHolder = ImageLoadingKind.local (UIImage(systemName: "video")!)
                let videItem = TestVideo(url: URL(string: "https://medchat.s3.amazonaws.com/0ad14146-690c-4a92-9341-b8fd5b226b1bD67F6B53-12E3-4AA9-9EF7-3991D33D914E.mov")!, placeholderImage: placeHolder, pictureInPicturePlayingMessage: "Video")
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .video(videItem, MessagePriorityLevel(rawValue: -1)!),isSender: true,status: .sent,
                                           messageUUID: UUID().uuidString))
                
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .audio(URL(string: "https://medchat.s3.amazonaws.com/7a865af9-1dc8-46e7-baa8-61a64d3b48fdrecorded-audio.mp3")!, MessagePriorityLevel(rawValue: -1)!),isSender: true,status: .sent,
                                           messageUUID: UUID().uuidString))
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .audio(URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!, MessagePriorityLevel(rawValue: -1)!),isSender: false,status: .sent,
                                           messageUUID: UUID().uuidString))
                
                
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("hello this is my number 09569051552", nil, .routine),isSender: false,status: .sent,
                                           messageUUID: UUID().uuidString))

                
                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("hello this is my number 09569051552", ["amigo","jett"], .routine),isSender: false,status: .sent,
                                           messageUUID: UUID().uuidString))

                

                self.messages.append(.init(user: MockMessages.chatbot, messageKind: .text("""

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam iaculis id massa at imperdiet. Curabitur porta orci mattis, commodo diam sit amet, auctor dolor. Donec quis orci at nisl facilisis imperdiet. Vestibulum finibus ipsum in venenatis gravida. Fusce vitae ante sapien. Duis nec dapibus tellus. Morbi eget massa eu leo tempus tristique sagittis sit amet mauris. Nunc accumsan turpis ut augue pharetra, non pretium quam placerat. Quisque gravida ante eget orci semper, a venenatis enim auctor. Aliquam cursus quam mauris, mattis molestie orci rhoncus vitae. Praesent blandit diam eros, vel finibus magna tincidunt non. Nunc eleifend urna ornare odio semper vulputate. Maecenas vulputate enim scelerisque, laoreet nibh eu, pulvinar lacus. Sed auctor magna nisl, nec fermentum tortor varius a.

Aliquam tempus rutrum hendrerit. Nulla condimentum, leo non commodo luctus, dui ante auctor ipsum, et blandit enim risus sed lectus. Nunc nibh lectus, viverra a semper et, fringilla vel libero. Maecenas in odio laoreet, hendrerit ligula ac, sagittis sem. Sed sed molestie purus. Duis sed justo mattis, placerat leo sit amet, blandit ante. Quisque in dolor bibendum, fringilla augue ac, mollis purus. Nam ut velit libero. Pellentesque mollis dui et neque consectetur sagittis.

Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Vestibulum tempor, augue rhoncus vestibulum tempor, neque nibh efficitur felis, sit amet tempus ante erat congue lacus. Praesent ultrices finibus urna, id hendrerit justo porta id. Fusce tincidunt elit id sem tristique congue. Fusce fermentum interdum eros, eget sollicitudin nisl consectetur sit amet. Sed sit amet sem eros. Sed condimentum enim dolor, in pulvinar sapien cursus sed. Nulla facilisi. Maecenas lobortis varius nisi sodales elementum.

Nullam fermentum ligula ut lorem tincidunt accumsan. In sit amet tincidunt metus. Etiam sed cursus lorem. Praesent mollis vel ipsum sit amet dapibus. Nulla vel ex facilisis, sagittis arcu eget, sollicitudin arcu. Donec nibh orci, mollis at turpis pretium, tincidunt accumsan magna. Aliquam mauris turpis, ultricies in molestie nec, congue eu nunc. Suspendisse potenti. Donec eu neque non sapien tempor efficitur. Sed posuere tincidunt orci, sed efficitur magna. Vivamus tortor eros, vulputate a turpis vitae, ultrices placerat sapien.

Ut sapien enim, auctor nec velit in, venenatis volutpat lacus. Fusce eget laoreet eros, et condimentum libero. Aenean id tempus elit, at pellentesque magna. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Fusce vestibulum a nibh sed condimentum. Aliquam pulvinar varius eleifend. Donec nec facilisis ex. Nulla facilisi. Donec eu vulputate neque.

Interdum et malesuada fames ac ante ipsum primis in faucibus. In dignissim lacus eu erat tincidunt ullamcorper. Duis interdum enim vitae finibus fermentum. Suspendisse potenti. Nam ut tristique massa, in pretium nisl. Sed ut aliquam risus, luctus malesuada sapien. Mauris sed tincidunt nulla. Sed volutpat mattis nisi, in tempor nulla luctus in. Integer eu metus augue. Quisque aliquam bibendum erat vel ornare. Donec sit amet eros id elit scelerisque interdum sit amet et mi.

Donec augue sem, lacinia ut purus in, luctus dictum est. Nulla ornare ipsum id aliquam rutrum. In hac habitasse platea dictumst. Cras malesuada turpis nisi, luctus malesuada quam euismod vitae. Proin efficitur dolor ut urna aliquet feugiat. Aliquam diam tellus, facilisis eu dictum ac, fermentum quis tellus. Cras posuere elementum finibus. Sed magna massa, pellentesque nec justo non, posuere mollis turpis.

Phasellus vitae est lorem. Nulla varius eget lectus facilisis lobortis. Praesent pellentesque eu nunc eget pretium. Morbi faucibus convallis molestie. Sed posuere ac lectus a tristique. In hac habitasse platea dictumst. Nullam id libero ultricies, blandit dui faucibus, tincidunt nulla. Phasellus malesuada mauris in nunc semper, ac accumsan dui placerat.

Quisque egestas felis enim, vitae tempor ligula pulvinar at. Suspendisse congue blandit hendrerit. Sed et orci dui. Pellentesque elementum et quam interdum pharetra. Aenean rhoncus sit amet ante et dapibus. Sed bibendum ac mauris non consectetur. Vestibulum non viverra ipsum. Proin sagittis leo sed nisl finibus, non aliquet ex tincidunt.

Sed blandit placerat turpis, ultricies rhoncus sem vulputate lobortis. Nunc id dui vel nibh consequat viverra. Suspendisse potenti. Aenean faucibus, diam quis eleifend rhoncus, ex lacus interdum lorem, nec ullamcorper justo lorem nec velit. Aliquam scelerisque tempus massa sit amet porta. Curabitur blandit porta elementum. Vestibulum cursus leo risus, eu hendrerit libero commodo non. Proin aliquet sagittis finibus. Cras ullamcorper dolor eget leo blandit, vitae egestas mauris blandit.

Proin feugiat at magna quis molestie. Phasellus in lorem at metus lobortis commodo. Nam diam lorem, facilisis non orci sit amet, eleifend viverra sem. Sed sagittis imperdiet justo ut fringilla. Curabitur auctor nisl neque, eu facilisis velit faucibus sit amet. Morbi eleifend est non sem sollicitudin facilisis. Quisque tincidunt massa vitae justo pellentesque bibendum. Ut fermentum mi massa, id porttitor sapien vulputate quis.

Curabitur dignissim, nisl sed dapibus accumsan, nisi arcu maximus ipsum, vitae faucibus odio dui vitae velit. Aliquam vitae commodo tellus, eget mollis lectus. Fusce laoreet augue vitae arcu sagittis, ac sollicitudin diam consectetur. Maecenas laoreet egestas congue. Mauris iaculis sodales eros, id malesuada neque tincidunt nec. Nullam ac volutpat orci. Vestibulum vulputate risus id nibh egestas mollis. Suspendisse potenti. Nam fermentum lorem id sollicitudin dapibus. Duis a orci in sem euismod elementum. Suspendisse ac enim in justo mattis tempus id vel nisl.

Phasellus at imperdiet nunc, euismod semper libero. Maecenas sollicitudin viverra varius. Cras vel viverra tortor. Nullam tincidunt facilisis odio, non lacinia turpis. Cras a velit pellentesque leo gravida blandit in vitae arcu. Aenean at rutrum nulla. Quisque eget suscipit mauris, eget lacinia nulla. Sed efficitur est luctus posuere vestibulum. Phasellus viverra posuere nulla nec vehicula. Maecenas suscipit ipsum ac ipsum hendrerit, nec tincidunt felis varius. Donec in mi id nibh viverra bibendum aliquet congue ex. Duis eu tellus tempus, aliquet ante vehicula, imperdiet tellus. Cras mollis tortor eget leo laoreet, id fermentum neque fringilla. Praesent mi nisl, porta sit amet finibus at, dignissim ac est.

Etiam sit amet velit neque. Duis convallis elit lectus, eu cursus metus rutrum eu. Nullam ultrices nulla a sapien condimentum, in semper sem aliquam. Sed aliquam massa a metus porttitor, a malesuada ante luctus. Vivamus semper efficitur suscipit. Curabitur elementum rutrum nunc eget faucibus. Phasellus lacinia tortor sit amet aliquet fringilla. Nullam eget tristique purus. Nam eget risus sed diam pharetra vehicula. Suspendisse maximus velit ligula. Suspendisse vulputate nulla scelerisque ligula rutrum sollicitudin. Nulla a feugiat augue, at tempor erat. Integer aliquet molestie elementum. Nulla rhoncus, velit viverra vulputate dapibus, felis lacus vestibulum augue, quis pretium quam diam in sem.

Etiam auctor id ex quis pellentesque. Phasellus tempus rhoncus ligula, sed blandit arcu facilisis vitae. Donec quis congue sem, non lacinia quam. Vestibulum dignissim nisl eget nulla rhoncus porta. Nam massa libero, ultrices et imperdiet id, sodales ut mi. Etiam tincidunt risus lacus, eleifend maximus eros tristique sed. Nunc fringilla, urna non porttitor faucibus, ex nunc gravida diam, quis sagittis magna urna at nibh. Ut tortor nunc, eleifend sed mi non, sodales ultrices nisi. Pellentesque non congue odio, vel feugiat ligula. Etiam non elementum dui. Duis at magna faucibus, interdum augue id, interdum sapien. Curabitur suscipit ullamcorper suscipit. Vivamus euismod augue eget tellus dapibus, sit amet sodales turpis egestas. Donec a eros fermentum, commodo arcu in, tempus lorem. Ut nec sollicitudin quam.

Integer consectetur placerat lectus ut elementum. Proin porta, ante ac elementum gravida, nunc mauris pulvinar nulla, eget eleifend arcu diam ut diam. Ut commodo, velit eu posuere efficitur, tortor dolor fermentum massa, a tempus orci eros ac diam. Nam vitae ex dignissim, condimentum dui ac, congue eros. Pellentesque vulputate pretium porta. Maecenas at tristique est, sit amet semper ex. Aliquam sagittis convallis nibh non aliquam. Mauris elementum suscipit varius. Ut ultricies egestas libero at suscipit. Nunc bibendum tortor sed erat pulvinar aliquet. Nullam at metus egestas, vestibulum ipsum eu, auctor risus. Aliquam erat volutpat. Curabitur vulputate lobortis metus, nec hendrerit tortor ultricies non. Praesent rhoncus eros sed convallis molestie. Phasellus vulputate sagittis aliquam. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Cras malesuada pulvinar metus vitae efficitur. Integer a finibus est. Aliquam in urna non felis varius porta vel sed nisi. Pellentesque posuere dapibus augue in euismod. Maecenas sit amet dui vitae nunc aliquam sodales. Sed at sodales massa, in blandit turpis. Phasellus magna sapien, congue ut volutpat non, laoreet et metus. Morbi vitae ipsum rutrum, hendrerit mauris non, ornare tellus. Nam efficitur, tellus eu fermentum ultrices, quam nisl blandit felis, eu viverra massa ex sit amet dolor. Curabitur vel nunc vel ex placerat sagittis at eget nisl. Mauris sem ligula, tincidunt sed euismod sit amet, porttitor ac nisi. Nam interdum molestie finibus. Vestibulum tempus nec ipsum a vulputate. Sed iaculis ultrices lorem semper tempus.

Aliquam erat ante, pulvinar vel lacus a, interdum ornare urna. Vestibulum arcu dui, tempor ac suscipit quis, fermentum ac ligula. Duis diam enim, congue et sapien ac, malesuada euismod nibh. Sed viverra semper rutrum. Donec vestibulum sem sit amet lectus gravida iaculis. Mauris in convallis enim, non tempor massa. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Mauris in eros nec odio scelerisque accumsan vel pellentesque quam. Nam accumsan interdum ligula nec venenatis.

Ut non mollis magna. Curabitur eget sapien tempus, maximus urna et, maximus nisl. Etiam molestie orci at elit suscipit interdum. Maecenas vel sapien augue. Duis blandit dictum metus a faucibus. Sed in elit eros. Pellentesque sollicitudin volutpat sem vel pharetra.

Quisque porttitor augue ut turpis maximus, ut efficitur metus condimentum. Donec vitae diam non elit lacinia malesuada eu sit amet dolor. Morbi quis posuere felis, at tincidunt odio. Vivamus et risus vitae libero viverra feugiat et congue urna. Praesent et laoreet libero. Suspendisse ipsum lectus, tristique ac posuere ac, lobortis a augue. In at interdum sapien. Sed est sem, congue sed nisi vitae, porta convallis erat. Duis vitae dui eget sem porta pharetra. Pellentesque mattis justo nec eros pellentesque, quis tincidunt nunc tincidunt. Sed purus ex, dapibus eu purus sed, suscipit viverra leo. Proin vestibulum neque sapien, at rhoncus metus fringilla a. Ut vestibulum congue tristique. Morbi nec lorem metus.

Fusce ac sem volutpat, egestas erat nec, semper tortor. Quisque non mattis est. Ut venenatis ex eget mattis sagittis. Nullam bibendum porta lorem, et sagittis risus aliquet quis. Nunc et dolor viverra, vehicula tellus eu, convallis nunc. Sed in nisl aliquam, feugiat quam ac, sollicitudin tortor. Morbi nec lacus vel justo pharetra aliquet sit amet et diam. Donec mauris dui, mattis in ex eget, euismod iaculis odio. Pellentesque id consequat arcu. Aenean vestibulum libero orci, egestas sagittis ex finibus tempus. Proin fermentum orci orci, ac elementum nulla consectetur eu. Integer id mauris sollicitudin, fringilla magna sit amet, vestibulum nisi. Integer feugiat, dui maximus tristique venenatis, urna justo euismod diam, at blandit metus augue ultrices nunc. Nullam congue posuere lacus vitae hendrerit. Sed id augue rutrum, luctus arcu gravida, consequat metus.

Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Sed a odio quis dui vulputate cursus eu nec velit. Pellentesque hendrerit hendrerit tempor. Integer nunc ipsum, fringilla at augue et, rutrum aliquam ligula. Integer sed dignissim ante. Quisque tristique sagittis nunc. Donec et luctus mauris. Duis auctor malesuada nibh. Ut elementum arcu vitae volutpat malesuada. Aenean eu laoreet augue. Vivamus eget felis et dui finibus molestie. Aliquam at nibh fermentum, fermentum purus non, posuere nunc. Quisque arcu ex, egestas convallis lacinia quis, condimentum ut sapien.

Quisque ut porta nibh, ut volutpat ante. Aliquam sed mi vitae est aliquet convallis in ut odio. Pellentesque quis laoreet lectus. Vivamus eu ex non neque tincidunt scelerisque. Nam volutpat enim sed molestie feugiat. Fusce fringilla condimentum enim ut mollis. Pellentesque sit amet convallis purus, pulvinar molestie dui. Nunc eget neque non nisi vestibulum semper sed nec enim. Nam id quam nulla. Pellentesque dapibus nibh congue varius faucibus. Pellentesque convallis gravida ante eu maximus. Sed eget magna quis ex sollicitudin facilisis nec ac velit.

Donec rhoncus ac nunc vel auctor. Curabitur arcu ipsum, eleifend eget maximus nec, hendrerit non lectus. Suspendisse potenti. In commodo odio quis lacinia cursus. Proin commodo ex non finibus dapibus. Nam in aliquet urna, id rutrum tortor. Aenean vehicula mi ac neque maximus lacinia.

Etiam ante sem, placerat sed eleifend in, eleifend ac diam. Fusce euismod tristique dignissim. Duis porttitor lobortis libero eu sodales. Praesent molestie dui eget libero venenatis, nec placerat magna imperdiet. Cras gravida posuere elit vitae maximus. Mauris dapibus varius elit, nec euismod metus condimentum in. Integer scelerisque at quam ac lobortis. Ut turpis lectus, porta a facilisis in, vulputate bibendum dui. Pellentesque eget erat augue. Phasellus dignissim turpis vitae arcu porta commodo. Ut ac enim augue.

Aliquam tempor erat sit amet orci egestas blandit. Vestibulum rhoncus feugiat tortor, nec volutpat mauris ultricies et. Maecenas consectetur neque nec massa accumsan, at ultrices velit maximus. Integer auctor, odio sed fermentum cursus, ante enim bibendum sem, et tempus eros tellus sit amet enim. Mauris vestibulum, nibh eget laoreet tincidunt, leo diam tempus lacus, ac tincidunt arcu massa fringilla nulla. Morbi dignissim, leo ac pharetra dignissim, elit sem molestie metus, id consectetur erat felis vel tortor. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam lobortis feugiat velit sit amet cursus. Donec ultricies ante nec ligula sagittis maximus. Mauris eget neque sed velit ullamcorper bibendum quis non ipsum. Interdum et malesuada fames ac ante ipsum primis in faucibus. Curabitur placerat est orci, at varius lorem convallis vehicula. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Quisque sed posuere felis. Vestibulum volutpat et orci congue vestibulum. Pellentesque metus ipsum, malesuada vitae sem vel, venenatis vehicula augue.

Suspendisse pellentesque odio ac turpis mollis gravida. Phasellus pulvinar ipsum at fringilla bibendum. Donec dignissim in neque convallis tempus. Aenean varius nunc metus, ut convallis felis feugiat nec. Praesent turpis arcu, elementum ut sollicitudin at, commodo eget neque. Quisque tincidunt urna vel molestie aliquet. Praesent ac gravida erat. Quisque non sem quam.

Duis scelerisque finibus turpis et convallis. Fusce vel tincidunt quam. Aliquam lobortis interdum finibus. Donec sodales lacus sit amet semper aliquet. In sagittis, justo eget fermentum hendrerit, ex metus fringilla felis, iaculis porta purus nibh vel mauris. Duis tristique neque ac lacus malesuada tincidunt. Ut ornare ipsum vitae diam egestas condimentum eu sed lectus. Aliquam vel nisl lacus. Vivamus quis dignissim urna. Morbi eu metus dapibus, ornare dui quis, volutpat magna. Phasellus at orci vitae est consectetur sollicitudin. Duis euismod tortor molestie turpis tempus mollis. Sed id ipsum eros.

Maecenas fermentum nunc ut risus faucibus fermentum. Nunc erat mauris, congue sed tempus non, ultricies at ex. Etiam accumsan lacinia felis, vel posuere nunc gravida ac. Nunc tincidunt eu tortor sed venenatis. Vestibulum vehicula diam sit amet consectetur dictum. Fusce consectetur nulla vitae odio semper, eu efficitur odio ultrices. Aliquam erat volutpat. Cras posuere tincidunt tincidunt. Pellentesque metus felis, varius vel turpis quis, dictum imperdiet augue. Mauris imperdiet commodo arcu ut fringilla. Sed nec tincidunt magna. Sed metus ante, venenatis eu massa non, lobortis pellentesque neque. Integer vehicula porta purus eget viverra. Cras dignissim, justo eu iaculis ornare, tortor sapien dapibus purus, quis lacinia purus augue sed dui. Praesent a turpis velit.

Mauris dolor ligula, semper id viverra ac, commodo ut risus. Donec sed mi in ante finibus varius at ut ipsum. Maecenas mauris justo, faucibus in turpis quis, facilisis sollicitudin purus. Donec ac gravida sapien. Aliquam vel convallis dui. Maecenas at metus quis metus dignissim cursus a congue massa. Maecenas commodo, neque sit amet varius ullamcorper, odio justo consequat ipsum, sed hendrerit turpis nunc eget magna. Nullam eu tempus ipsum. Vestibulum accumsan nunc in hendrerit dignissim. Maecenas volutpat ac urna ac lobortis. Pellentesque a ultricies velit, luctus mattis felis.

Vivamus sollicitudin suscipit lectus, id sagittis erat rutrum ut. Nullam imperdiet pellentesque magna, sodales lobortis tortor pretium et. Fusce congue nisl sit amet volutpat vulputate. Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed imperdiet volutpat ligula cursus scelerisque. Pellentesque tempor a mi nec auctor. Mauris dolor diam, congue eu nunc vel, iaculis efficitur est. Nunc posuere eu erat a posuere.

In hac habitasse platea dictumst. Cras non lorem risus. Duis velit felis, lobortis ut metus ut, malesuada luctus eros. Nullam iaculis ornare aliquam. Vestibulum odio lorem, sodales at pellentesque ac, porttitor vitae diam. Duis at malesuada diam. Aenean hendrerit erat eros, ut pulvinar odio ultricies vitae. Curabitur id aliquet purus, a aliquam justo. Etiam eget elit mauris. Mauris dignissim turpis aliquet lorem dapibus, eu gravida ipsum ultricies. Nunc sodales ligula in interdum accumsan. In leo augue, iaculis eget molestie nec, sodales quis tortor. Vivamus lacinia condimentum porta.

Vivamus non arcu quam. Pellentesque pharetra in odio a facilisis. Quisque sit amet dui enim. Mauris auctor turpis quis risus finibus tempor. Donec vehicula feugiat nisl, a fermentum elit lacinia ut. Quisque lacinia sem ut risus aliquet, eget eleifend eros dignissim. Donec pulvinar mauris non nunc eleifend viverra. Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed magna augue, rhoncus dapibus consequat nec, imperdiet vitae mauris. Sed ultricies, massa tincidunt elementum pellentesque, tortor purus vulputate urna, et volutpat diam eros nec mi. Donec a libero finibus, imperdiet urna sed, rhoncus odio. Praesent posuere nisl at est vulputate sagittis. Aenean a enim eget sem mollis eleifend. Sed a facilisis felis. Proin at bibendum dolor.

Quisque vulputate lacus vel pharetra blandit. Integer ac accumsan arcu. Phasellus laoreet eleifend accumsan. Pellentesque pharetra eu augue sit amet vulputate. In id odio ut ex lobortis semper. Suspendisse vitae mauris arcu. Aliquam tortor magna, sodales at congue ut, venenatis sed ex. Suspendisse maximus ut eros in faucibus. Duis vitae diam eget eros luctus rutrum. Aliquam sagittis suscipit lorem sed venenatis. In auctor lacus at lorem vulputate, vitae dignissim eros facilisis. Praesent sed malesuada orci. Phasellus in laoreet nisi, sit amet egestas eros. Ut bibendum sagittis erat, vitae sodales sem porta ut.

Duis mi lectus, vulputate et lectus et, mollis vestibulum ligula. Mauris laoreet luctus ex, vel sollicitudin arcu feugiat non. Sed tincidunt, mi id semper efficitur, lectus augue molestie nisi, et convallis velit urna a orci. Mauris efficitur a nulla in pretium. Mauris non sapien ultricies, ullamcorper neque eget, eleifend massa. Vestibulum ligula ex, egestas non luctus nec, rhoncus pharetra lorem. Curabitur eu fermentum dui. Quisque cursus mi sed sem lacinia, imperdiet feugiat dolor hendrerit. Vivamus pellentesque lorem et arcu blandit, sit amet euismod turpis pulvinar. Proin vel lorem dui. Quisque in laoreet velit.

Vestibulum risus leo, cursus et tempor id, suscipit id dolor. Nunc tincidunt arcu vitae metus suscipit vulputate sed quis justo. Aenean vel massa tempus, porta justo et, elementum dolor. Praesent sagittis, leo vitae elementum malesuada, nibh risus mollis dui, ut tincidunt lorem libero vitae lacus. Maecenas in felis felis. Fusce a eleifend orci, ut pretium lacus. Proin lacus nisi, sagittis vitae malesuada id, pulvinar quis orci.

Quisque accumsan facilisis eros, in congue libero. Integer molestie dolor eu euismod egestas. Pellentesque eleifend lectus eu enim sagittis, sed porta tortor mollis. Suspendisse mattis sollicitudin dolor nec mattis. Fusce ac nulla vel nisl egestas congue. Integer vitae scelerisque tellus, a luctus massa. Suspendisse id finibus magna, eget tincidunt ipsum. Etiam orci elit, eleifend porta nibh et, ornare consequat urna. Maecenas auctor rutrum lectus id eleifend.

Maecenas congue, lorem ac pulvinar laoreet, orci metus lacinia quam, sed vestibulum leo mi non elit. Nam a dolor ut odio dignissim accumsan nec vitae purus. Vestibulum eget viverra dui. Proin condimentum ultricies arcu, nec laoreet ante tincidunt in. Suspendisse sit amet est quam. In in velit nunc. Praesent maximus metus a leo imperdiet, vitae lacinia ante fringilla.

Vivamus sodales quis augue in rhoncus. Nullam vestibulum nunc id lectus egestas, ut posuere nunc bibendum. Maecenas nec venenatis quam. Nullam sed nulla eget metus tempus tincidunt ultrices eget nibh. Mauris finibus pretium lectus id mollis. Nam nec felis non sem tristique aliquet. Mauris fringilla consectetur dui eu interdum. Praesent luctus vestibulum nulla, sit amet aliquet urna sodales in. Proin vehicula lacinia odio non ornare. Curabitur euismod accumsan velit, nec molestie orci consequat a. Morbi in sem sit amet ligula bibendum tempus ac non nisl. Cras augue risus, semper egestas massa et, tincidunt vestibulum turpis.

Mauris malesuada, massa vitae aliquam posuere, sapien felis egestas mi, ac cursus risus quam eget ex. Donec iaculis lacus dolor. Vestibulum ac ligula sed justo placerat mattis in non lorem. Sed ultrices vehicula ligula, eu varius elit pulvinar ac. Nunc at scelerisque magna. Morbi tempor ullamcorper mauris eu eleifend. Morbi finibus sagittis condimentum. Curabitur a metus nec ipsum dapibus bibendum. Aliquam consequat orci eget sapien tristique, sed eleifend lorem egestas. Donec sagittis tincidunt velit, quis imperdiet mauris. Phasellus in lectus non nibh finibus dapibus id et lectus. Vivamus iaculis ipsum eget sollicitudin commodo. Aenean convallis ac lectus quis commodo. Sed nulla sapien, imperdiet sed nulla tempus, interdum molestie augue. Phasellus eget posuere ligula. Suspendisse tincidunt aliquam nulla, nec convallis sapien auctor quis.

Pellentesque dignissim dapibus auctor. Vivamus vestibulum dolor sit amet mauris feugiat tincidunt nec quis mi. Curabitur risus lorem, tempus nec orci sed, lacinia elementum ipsum. Etiam porttitor et tellus vulputate suscipit. Duis justo lorem, bibendum at metus non, consequat viverra justo. Sed dapibus erat mi, ac mattis enim consectetur vitae. Ut accumsan mauris lectus, vel tempus elit porttitor in. Nullam at mi in massa accumsan egestas. Integer ut est erat. Donec et nisi neque. Cras blandit nulla turpis, ac ornare nisl maximus et. Cras metus arcu, mollis non nulla eu, semper consectetur dolor. Sed posuere, mauris vitae ultrices efficitur, lectus sem facilisis eros, ac sodales augue augue sit amet diam. Fusce massa lacus, tincidunt ut purus eu, pulvinar venenatis lacus. Nulla placerat tristique semper. Proin ante nisi, elementum sed scelerisque eget, feugiat mattis diam.

Nulla dui quam, tincidunt vitae tortor et, mollis fermentum sapien. Curabitur maximus dignissim diam sed rutrum. Sed quis enim fringilla felis viverra sollicitudin. Donec at commodo sem. Aliquam elementum, ipsum eu posuere varius, velit dui convallis ante, a consectetur elit neque vitae lectus. Vivamus sed sapien fermentum, condimentum tellus a, tempor turpis. Curabitur non tempor velit.

Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Cras eget aliquet dui, sit amet egestas ante. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nullam eget lectus vestibulum, venenatis risus eu, malesuada ligula. Vivamus lobortis magna nec porta tincidunt. Aliquam posuere tellus at magna sollicitudin dapibus. Duis tempus metus sit amet posuere aliquam. Donec consequat quam vel fermentum volutpat. Nunc non tempor elit, ultrices facilisis arcu. Suspendisse auctor ipsum nisi, sed eleifend lorem porta in. Nulla facilisi. Aenean pretium, massa vel congue congue, urna urna fermentum lorem, quis sollicitudin augue nunc in purus. Vivamus vitae turpis tristique, blandit velit vitae, lacinia odio. Phasellus pharetra finibus rutrum. Integer velit nunc, blandit ut lacus id, pellentesque eleifend est.

Nunc faucibus ultricies nibh in pellentesque. Sed nec mi dapibus, porta metus non, condimentum nisl. In hac habitasse platea dictumst. Morbi nec augue finibus, congue magna nec, cursus dui. Vestibulum tempus egestas arcu in pretium. Nulla accumsan purus augue, ac volutpat nunc luctus ac. Donec est velit, tristique at orci ut, rhoncus molestie dui. Nulla ut mauris quis justo gravida mollis. In hac habitasse platea dictumst. Praesent malesuada ligula at turpis dignissim aliquam. Nullam semper felis nec est luctus accumsan. Curabitur interdum dui quis metus maximus, a ultrices dui pellentesque. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae;

Curabitur id interdum diam, non faucibus est. Integer et nunc at erat blandit pulvinar id non dui. Aliquam ac erat malesuada, blandit enim at, mattis ante. Vestibulum imperdiet, urna eu vulputate tincidunt, lorem lectus mollis dolor, a ultricies felis eros id enim. Proin tempor felis lectus, non fermentum turpis placerat ut. Vivamus risus mauris, scelerisque non imperdiet in, pharetra eget ligula. Interdum et malesuada fames ac ante ipsum primis in faucibus. Donec pulvinar id eros id venenatis. Mauris maximus, nulla eget fermentum bibendum, nunc nisl cursus nisl, ut aliquam sapien ante ut sapien. Suspendisse consequat luctus orci, sed suscipit augue sodales a. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Pellentesque ornare malesuada purus vitae congue. Vestibulum a efficitur est. Fusce maximus sit amet tortor quis rhoncus. In sollicitudin ligula pharetra, scelerisque tortor eu, posuere odio. Donec non ex eget mauris commodo malesuada.

Morbi et tellus ut nunc gravida feugiat id ut libero. Quisque aliquam nec tortor eu bibendum. Duis a nisi sit amet nulla vestibulum pulvinar. Cras porttitor dolor ac leo sollicitudin lobortis. Ut feugiat ultricies placerat. Maecenas porta tincidunt lorem, non venenatis tortor dignissim non. Phasellus congue urna id augue egestas, id dictum sapien semper.

In velit odio, molestie sed metus ut, mattis aliquet dolor. Etiam quis urna venenatis, tristique nisi a, varius ex. Donec eu luctus diam, ac molestie quam. Proin ac ex sit amet augue maximus feugiat eget tincidunt augue. Mauris dictum neque sed viverra auctor. Phasellus cursus mi sed purus efficitur, id hendrerit lacus semper. Suspendisse potenti. Donec finibus, elit sit amet tempus placerat, magna tortor accumsan tellus, vitae tincidunt justo ipsum vitae elit. Nulla facilisis leo vitae faucibus mattis. Pellentesque aliquet venenatis augue, id aliquet leo ornare non. Fusce id risus blandit, pellentesque magna ut, posuere leo. Fusce vel lorem vel lacus facilisis dapibus. In sodales augue in enim dignissim porttitor. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Praesent posuere nisi in est mollis consectetur et sit amet lectus.

Cras ac porttitor diam. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed dictum ex vitae sem ultricies egestas. Nam consequat nibh eu sem placerat aliquet. Donec faucibus, nunc et ornare luctus, justo urna tincidunt felis, et tempus urna sapien non diam. Morbi nisl diam, varius eget congue sed, tincidunt eu libero. Proin ut eleifend orci. Nulla eu magna id nibh fringilla fringilla.

Aenean sit amet nibh id tellus hendrerit ultricies vel sed neque. In pharetra metus in augue egestas pellentesque. Nunc congue eros a imperdiet euismod. Praesent in tellus tortor. Proin porta a mi a mollis. Curabitur et interdum est, ut feugiat lacus. Mauris accumsan sodales sapien nec lacinia. Mauris in turpis magna. Nunc blandit viverra ligula, vel fringilla metus rhoncus id. Nunc scelerisque tempor felis, sit amet tempus tellus eleifend non.

Proin ex ante, sollicitudin eu consequat sit amet, facilisis ac sapien. Nulla dolor dui, molestie et congue ac, malesuada at lorem. Donec eleifend non mi non volutpat. Curabitur ac libero bibendum, aliquam nisi eu, vehicula nibh. Cras arcu tellus, facilisis ut ullamcorper id, ultricies ac nisl. Fusce eu est vitae metus ultricies vehicula ac ut lorem. Nunc lobortis elit id risus pulvinar porta. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Pellentesque efficitur porttitor nulla varius placerat. Integer porta luctus nunc. Donec nec tempus odio, vulputate efficitur elit. Aliquam commodo mattis sem sit amet bibendum.

Fusce sodales eget sem et venenatis. Nam consequat lorem quis diam pharetra iaculis. Donec vel volutpat nisi. Integer porta finibus finibus. Pellentesque sagittis urna in nisi eleifend aliquet. Nulla nec hendrerit erat. In pulvinar lacus quis efficitur tincidunt. Nam lobortis, nulla et fringilla euismod, mauris augue posuere justo, vel efficitur libero neque auctor sem

""", nil, MessagePriorityLevel(rawValue: -1)!),isSender: true,status: .sent,
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
