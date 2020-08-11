//
//  MockMessages.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import class UIKit.UIImage
import Foundation

public struct MockMessages {
    
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
    
    public static let sender = ChatUser(
        userName: "Sender",
        avatarURL: URL(string: "https://ebbot.ai/wp-content/uploads/2020/04/Ebbot-Sa%CC%88ljsa%CC%88l.png")
    )
    public static let chatbot = ChatUser(
        userName: "Chatbot",
        //        avatar: #imageLiteral(resourceName: "avatar")
        avatarURL: URL(string: "https://3.bp.blogspot.com/-vO7C5BPCaCQ/WigyjG6Q8lI/AAAAAAAAfyQ/1tobZMMwZ2YEI0zx5De7kD31znbUAth0gCLcBGAs/s200/TOMI_avatar_full.png")
    )
    
    private static var randomUser: ChatUser {
        [sender, chatbot].randomElement()!
    }
    
    
    public static var mockImages: [UIImage] = []
    
    public static func generateMessage(kind: ChatMessageKind) -> ChatMessage {
        let randomUser = Self.randomUser
        switch kind {
        case .image:
            guard let randomImage = mockImages.randomElement() else { fallthrough }
            return .init(
                user: randomUser,
                messageKind: .image(.local(randomImage)),
                isSender: randomUser == Self.sender
            )
        case .text:
            return .init(
                user: randomUser,
                messageKind: .text(Lorem.sentence()),
                isSender: randomUser == Self.sender
            )
            
        case .carousel:
            return .init(
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
            
        case .quickReply:
            let quickReplies: [QuickReplyRow] = (0...Int.random(in: 1...4)).map { idx in
                return QuickReplyRow(title: "Option.\(idx)", payload: "opt\(idx)")
            }
            return .init(
                user: randomUser,
                messageKind: .quickReply(quickReplies),
                isSender: randomUser == Self.sender
            )
        case .location:
            let location = LocationRow(
                latitude: Double.random(in: 36...42),
                longitude: Double.random(in: 26...45)
            )
            return .init(
                user: randomUser,
                messageKind: .location(location),
                isSender: randomUser == Self.sender
            )
        case .contact:
            let contacts = [
                ContactRow(displayName: "Enes Karaosman"),
                ContactRow(displayName: "Adam Surname"),
                ContactRow(displayName: "Name DummySurname")
            ]
            return .init(
                user: randomUser,
                messageKind: .contact(contacts.randomElement()!),
                isSender: randomUser == Self.sender
            )
        default:
            return .init(
                user: randomUser,
                messageKind: .text("Bom!"),
                isSender: randomUser == Self.sender
            )
        }
    }
    
    public static var randomMessageKind: ChatMessageKind {
        let allCases: [ChatMessageKind] = [
            .image(.local(UIImage())),
            .text(""), .text(""), .text(""),
            .contact(ContactRow(displayName: "")),
            .text(""), .text(""), .text(""),
            .carousel([]),
            .location(LocationRow(latitude: .zero, longitude: .zero)),
            .text(""), .text(""), .text(""),
            .quickReply([])
        ]
        return allCases.randomElement()!
    }
    
    public static func generatedMessages(count: Int = 30) -> [ChatMessage] {
        return (1...count).map { _ in generateMessage(kind: randomMessageKind)}
    }
    
}
