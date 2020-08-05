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
    
    public static let sender = ChatUser(
        userName: "Sender",
        avatarURL: URL(string: "https://ebbot.ai/wp-content/uploads/2020/04/Ebbot-Sa%CC%88ljsa%CC%88l.png")
    )
    public static let chatbot = ChatUser(
        userName: "Chatbot",
        avatarURL: URL(string: "https://3.bp.blogspot.com/-vO7C5BPCaCQ/WigyjG6Q8lI/AAAAAAAAfyQ/1tobZMMwZ2YEI0zx5De7kD31znbUAth0gCLcBGAs/s200/TOMI_avatar_full.png")
    )
    
    private static var randomUser: ChatUser {
        [sender, chatbot].randomElement()!
    }
    
    /// Concrete model for Location
    private struct LocationRow: LocationItem {
        var latitude: Double
        var longitude: Double
    }
    
    /// Concrete model for Contact
    private struct ContactRow: ContactItem {
        var displayName: String
        var image: UIImage?
        var initials: String = ""
        var phoneNumbers: [String] = []
        var emails: [String] = []
    }
    
    public static var mockImages: [UIImage] = []
    
    public static let messages: [ChatMessage] = [
        .init(user: Self.sender, messageKind: .text("Hi, can I ask you something!"), isSender: true),
        .init(user: Self.chatbot, messageKind: .text("Of course!")),
        .init(
            user: Self.sender,
            messageKind: .text("Okay than i am going to ask you a long question to check how row behaves, you ready?\nWhere are you now??"),
            isSender: true
        ),
        .init(user: Self.chatbot, messageKind: .location(LocationRow(latitude: 41.04192, longitude: 28.966912))),
        .init(user: Self.chatbot, messageKind: .text("Here is photo")),
        .init(user: Self.sender, messageKind: .image(.local(UIImage(named: "landscape")!)), isSender: true),
        .init(user: Self.chatbot, messageKind: .text("😲")),
        .init(user: Self.chatbot, messageKind: .text("Here what I have..")),
        .init(user: Self.sender, messageKind: .image(.local(UIImage(named: "portrait")!)), isSender: true),
        .init(user: Self.chatbot, messageKind: .text("😎😎")),
        .init(user: Self.chatbot, messageKind: .text("Now it's my turn, I'll send you a link but can you open it 🤯😎\n https://github.com/EnesKaraosman/SwiftyChat")),
        .init(user: Self.sender, messageKind: .text("Not now but maybe later.."), isSender: true)
    ]
    
    public static func generateMessage(kind: ChatMessageKind) -> ChatMessage {
        switch kind {
        case .image:
            guard let randomImage = mockImages.randomElement() else { fallthrough }
            return .init(
                user: Self.randomUser,
                messageKind: .image(.local(randomImage)),
                isSender: Self.randomUser == Self.sender
            )
        case .text:
            return .init(
                user: Self.randomUser,
                messageKind: .text(Lorem.sentence()),
                isSender: Self.randomUser == Self.sender
            )
        case .quickReply:
            let quickReplies = [
                QuickReplyItem(title: "Option1", payload: "opt1"),
                QuickReplyItem(title: "Option2", payload: "opt2"),
                QuickReplyItem(title: "Option3", payload: "opt3")
            ]
            return .init(
                user: Self.randomUser,
                messageKind: .quickReply(quickReplies),
                isSender: Self.randomUser == Self.sender
            )
        case .location:
            let location = LocationRow(
                latitude: Double.random(in: 36...42),
                longitude: Double.random(in: 26...45)
            )
            return .init(
                user: Self.randomUser,
                messageKind: .location(location),
                isSender: Self.randomUser == Self.sender
            )
        case .contact:
            let contacts = [
                ContactRow(displayName: "Enes Karaosman"),
                ContactRow(displayName: "Adam Surname"),
                ContactRow(displayName: "Name DummySurname")
            ]
            return .init(
                user: Self.randomUser,
                messageKind: .contact(contacts.randomElement()!),
                isSender: Self.randomUser == Self.sender
            )
        default:
            return .init(
                user: Self.randomUser,
                messageKind: .text("Bom!"),
                isSender: Self.randomUser == Self.sender
            )
        }
    }
    
    public static var randomMessageKind: ChatMessageKind {
        let allCases: [ChatMessageKind] = [
            .image(.local(UIImage())),
            .text(""), .text(""), .text(""),
            .contact(ContactRow(displayName: "")),
            .text(""), .text(""), .text(""),
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
