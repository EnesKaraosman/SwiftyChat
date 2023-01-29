//
//  MockMessages.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import UIKit
import Foundation

internal extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

public struct MockMessages {
    
    public enum Kind {
        case Text
        case Image
        case Location
        case Contact
        case QuickReply
        case Carousel
        case Video
        case Custom
        
        private var messageKind: ChatMessageKind {
            switch self {
            case .Text: return .text("")
            case .Image: return .image(.remote(URL(string: "")!))
            case .Location: return .location(LocationRow(latitude: .nan, longitude: .nan))
            case .Contact: return .contact(ContactRow(displayName: ""))
            case .QuickReply: return .quickReply([])
            case .Carousel: return .carousel([CarouselRow(title: "", imageURL: nil, subtitle: "", buttons: [])])
            case .Video: return .video(VideoRow(url: URL(string: "")!, placeholderImage: .remote(URL(string: "")!), pictureInPicturePlayingMessage: ""))
            case .Custom: return .custom("")
            }
        }
    }
    
    // MARK: - Concrete model for Location
    private struct LocationRow: LocationItem {
        var latitude: Double
        var longitude: Double
    }
    
    // MARK: - Concrete model for Contact
    private struct ContactRow: ContactItem {
        var displayName: String
        var image: UIImage?
        var initials: String = ""
        var phoneNumbers: [String] = []
        var emails: [String] = []
    }
    
    // MARK: - Concrete model for QuickReply
    private struct QuickReplyRow: QuickReplyItem {
        var title: String
        var payload: String
    }
    
    // MARK: - Concrete model for Carousel
    private struct CarouselRow: CarouselItem {
        var title: String
        var imageURL: URL?
        var subtitle: String
        var buttons: [CarouselItemButton]
    }
    
    // MARK: - Concrete model for Video
    private struct VideoRow: VideoItem {
        var url: URL
        var placeholderImage: ImageLoadingKind
        var pictureInPicturePlayingMessage: String
    }
    
    // MARK: - Concrete model for ChatMessage
    public struct ChatMessageItem: ChatMessage {
        
        public let id = UUID()
        public var user: ChatUserItem
        public var messageKind: ChatMessageKind
        public var isSender: Bool
        public var date: Date

        public init(
            user: ChatUserItem,
            messageKind: ChatMessageKind,
            isSender: Bool = false,
            date: Date = .init()
        ) {
            self.user = user
            self.messageKind = messageKind
            self.isSender = isSender
            self.date = date
        }
    }
    
    // MARK: - Concrete model for ChatUser
    public struct ChatUserItem: ChatUser {

        public static func == (lhs: ChatUserItem, rhs: ChatUserItem) -> Bool {
            lhs.id == rhs.id
        }

        public let id = UUID().uuidString
        
        /// Username
        public var userName: String
        
        /// User's chat profile image, considered if `avatarURL` is nil
        public var avatar: UIImage?
        
        /// User's chat profile image URL
        public var avatarURL: URL?

        public init(userName: String, avatarURL: URL? = nil, avatar: UIImage? = nil) {
            self.userName = userName
            self.avatar = avatar
            self.avatarURL = avatarURL
        }
        
    }
    
    public static var sender: ChatUserItem = .init(
        userName: "Sender",
        avatarURL: URL(string: "https://ebbot.ai/wp-content/uploads/2020/04/Ebbot-Sa%CC%88ljsa%CC%88l.png")
    )
    
    public static var chatbot: ChatUserItem = .init(
        userName: "Chatbot",
        //        avatar: #imageLiteral(resourceName: "avatar")
        avatarURL: URL(string: "https://3.bp.blogspot.com/-vO7C5BPCaCQ/WigyjG6Q8lI/AAAAAAAAfyQ/1tobZMMwZ2YEI0zx5De7kD31znbUAth0gCLcBGAs/s200/TOMI_avatar_full.png")
    )
    
    private static var randomUser: ChatUserItem {
        [sender, chatbot].randomElement()!
    }
    
    public static var mockImages: [UIImage] = []
    
    public static func generateMessage(kind: MockMessages.Kind, count: UInt) -> [ChatMessageItem] {
        (1...count).map { _ in generateMessage(kind: kind) }
    }
    
    public static func generateMessage(kind: MockMessages.Kind) -> ChatMessageItem {
        let randomUser = Self.randomUser
        switch kind {
        
        case .Image:
            guard let url = URL(string: "https://picsum.photos/id/\(Int.random(in: 1...100))/400/300") else { fallthrough }
            return ChatMessageItem(
                user: randomUser,
                messageKind: .image(.remote(url)),
                isSender: randomUser == Self.sender
            )
            
        case .Text:
            return ChatMessageItem(
                user: randomUser,
                messageKind: .text(Lorem.sentence()),
                isSender: randomUser == Self.sender
            )
            
        case .Carousel:
            return ChatMessageItem(
                user: Self.chatbot,
                messageKind: .carousel([
                    CarouselRow(
                        title: "Multiline Title",
//                        imageURL: URL(string:"https://picsum.photos/400/300"),
                        imageURL: URL(string: "https://picsum.photos/id/1/400/200"),
                        subtitle: "Multiline Subtitle, you do not believe me ?",
                        buttons: [
                            CarouselItemButton(title: "Action Button")
                        ]
                    ),
                    CarouselRow(
                        title: "This one is really multiline",
//                        imageURL: URL(string:"https://picsum.photos/400/300"),
                        imageURL: URL(string: "https://picsum.photos/id/2/400/200"),
                        subtitle: "Multilinable Subtitle",
                        buttons: [
                            CarouselItemButton(title: "Tap me!")
                        ]
                    )
                ]),
                isSender: false
            )
            
        case .QuickReply:
            let quickReplies: [QuickReplyRow] = (1...Int.random(in: 2...4)).map { idx in
                return QuickReplyRow(title: "Option.\(idx)", payload: "opt\(idx)")
            }
            return ChatMessageItem(
                user: randomUser,
                messageKind: .quickReply(quickReplies),
                isSender: randomUser == Self.sender
            )
            
        case .Location:
            let location = LocationRow(
                latitude: Double.random(in: 36...42),
                longitude: Double.random(in: 26...45)
            )
            return ChatMessageItem(
                user: randomUser,
                messageKind: .location(location),
                isSender: randomUser == Self.sender
            )
            
        case .Contact:
            let contacts = [
                ContactRow(displayName: "Enes Karaosman"),
                ContactRow(displayName: "Adam Surname"),
                ContactRow(displayName: "Name DummySurname")
            ]
            return ChatMessageItem(
                user: randomUser,
                messageKind: .contact(contacts.randomElement()!),
                isSender: randomUser == Self.sender
            )
            
        case .Video:
            let videoItem = VideoRow(
                url: URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!,
                placeholderImage: .remote(URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg")!),
                pictureInPicturePlayingMessage: "This video is playing in picture in picture."
            )
            return ChatMessageItem(
                user: randomUser,
                messageKind: .video(videoItem),
                isSender: randomUser == Self.sender
            )
        case .Custom:
            return ChatMessageItem(
                user: randomUser,
                messageKind: .custom(Lorem.sentence()),
                isSender: randomUser == Self.sender
            )
            
        }
    }
    
    public static var randomMessageKind: MockMessages.Kind {
        let allCases: [MockMessages.Kind] = [
            .Image,
            .Text, .Text, .Text,
            .Contact,
            .Text, .Text, .Text,
            .Carousel,
            .Location,
            .Text, .Text, .Text,
            .Video,
            .QuickReply,
            .Custom
        ]
        return allCases.randomElement()!
    }
    
    public static func generatedMessages(count: Int = 30) -> [ChatMessageItem] {
        return (1...count).map { _ in generateMessage(kind: randomMessageKind)}
    }
    
}
