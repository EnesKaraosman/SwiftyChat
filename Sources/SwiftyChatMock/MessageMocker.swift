//
//  MockMessages.swift
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

// swiftlint:disable identifier_name

import Foundation
import SwiftyChat

public struct MessageMocker {

    public enum Kind {
        case text
        case image
        case imageText
        case location
        case contact
        case quickReply
        case carousel
        case video
        case linkPreview
        case custom
    }
    
    private static func avatarUrl(_ id: Int) -> URL? {
        let string = "https://github.com/radically-straightforward/radically-straightforward/blob/main/examples/avatars/png/\(id).png?raw=true"
        return URL(string: string)
    }

    public static let sender: ChatUserItem = .init(
        userName: "Sender",
        avatarURL: avatarUrl(Int.random(in: 1...250))
    )

    public static let chatbot: ChatUserItem = .init(
        userName: "Chatbot",
        avatarURL: avatarUrl(Int.random(in: 1...250))
    )

    private static var randomUser: ChatUserItem {
        [sender, chatbot].randomElement()!
    }

    public static func generate(kind: MessageMocker.Kind, count: UInt) -> [ChatMessageItem] {
        (1...count).map { _ in generate(kind: kind) }
    }

    public static func generate(kind: MessageMocker.Kind) -> ChatMessageItem {
        let randomUser = Self.randomUser

        switch kind {

        case .image:
            let randomId = Int.random(in: 1...100)
            guard let url = URL(string: "https://picsum.photos/id/\(randomId)/800/600") else {
                fallthrough
            }

            return ChatMessageItem(
                user: randomUser,
                messageKind: .image(.remote(url)),
                isSender: randomUser == Self.sender
            )

        case .text:
            return ChatMessageItem(
                user: randomUser,
                messageKind: .text(Lorem.sentence()),
                isSender: randomUser == Self.sender
            )

        case .imageText:
            let randomId = Int.random(in: 1...100)
            guard let url = URL(string: "https://picsum.photos/id/\(randomId)/800/600") else {
                fallthrough
            }

            return ChatMessageItem(
                user: randomUser,
                messageKind: .imageText(.remote(url), Lorem.sentence()),
                isSender: randomUser == Self.sender
            )

        case .carousel:
            return ChatMessageItem(
                user: Self.chatbot,
                messageKind: .carousel([
                    CarouselRow(
                        title: "Multiline Title",
                        imageURL: URL(string: "https://picsum.photos/id/1/400/200"),
                        subtitle: "Multiline Subtitle, you do not believe me ?",
                        buttons: [
                            CarouselItemButton(title: "Action Button")
                        ]
                    ),
                    CarouselRow(
                        title: "This one is really multiline",
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
            let quickReplies: [QuickReplyRow] = (1...Int.random(in: 2...4)).map { idx in
                return QuickReplyRow(title: "Option.\(idx)", payload: "opt\(idx)")
            }
            return ChatMessageItem(
                user: randomUser,
                messageKind: .quickReply(quickReplies),
                isSender: randomUser == Self.sender
            )

        case .location:
            let location = LocationRow(
                latitude: Double.random(in: 36...42),
                longitude: Double.random(in: 26...45)
            )
            return ChatMessageItem(
                user: randomUser,
                messageKind: .location(location),
                isSender: randomUser == Self.sender
            )

        case .contact:
            let contacts = [
                ContactRow(displayName: "Enes Karaosman"),
                ContactRow(displayName: "John Doe"),
                ContactRow(displayName: "Serdar Bale")
            ]
            return ChatMessageItem(
                user: randomUser,
                messageKind: .contact(contacts.randomElement()!),
                isSender: randomUser == Self.sender
            )

        case .video:
            let videoItem = VideoRow(
                url: URL(string: "https://loremipsum.video/vt/powerpoint-1.mp4")!,
                placeholderImage: .remote(URL(string: "https://loremipsum.video/img/id_vts/powerpoint-1.png")!),
                pictureInPicturePlayingMessage: "This video is playing in picture in picture."
            )

            return ChatMessageItem(
                user: randomUser,
                messageKind: .video(videoItem),
                isSender: randomUser == Self.sender
            )
        case .linkPreview:
            let linkItem = LinkPreviewRow(
                url: URL(string: "https://github.com/EnesKaraosman/SwiftyChat")!,
                title: "SwiftyChat - A SwiftUI Chat UI Library",
                description: "A lightweight chat UI framework built entirely in SwiftUI, supporting text, images, video, location, contacts, and more.",
                imageURL: URL(string: "https://opengraph.githubassets.com/1/EnesKaraosman/SwiftyChat"),
                host: "github.com"
            )
            return ChatMessageItem(
                user: randomUser,
                messageKind: .linkPreview(linkItem),
                isSender: randomUser == Self.sender
            )

        case .custom:
            return ChatMessageItem(
                user: randomUser,
                messageKind: .custom("Custom Message Kind 😍🥰"),
                isSender: randomUser == Self.sender
            )
        }
    }

    public static var randomMessageKind: MessageMocker.Kind {
        return [
            .image,
            .text, .text,
            .image,
            .text, .text,
            .imageText,
            .contact,
            .text, .text,
            .carousel,
            .text, .text,
            .location,
            .text, .text,
            .video,
            .text, .text,
            .linkPreview,
            .text, .text,
            .quickReply,
            .custom
        ].randomElement()!
    }

    public static func generate(count: Int = 30) -> [ChatMessageItem] {
        (1...count).map { _ in generate(kind: randomMessageKind)}
    }
}

// MARK: - Concrete implementation for message protocols
extension MessageMocker {
    private struct LocationRow: LocationItem {
        var latitude: Double
        var longitude: Double
    }

    private struct ContactRow: ContactItem {
        var displayName: String
        var image: PlatformImage?
        var initials: String = ""
        var phoneNumbers: [String] = []
        var emails: [String] = []
    }

    private struct QuickReplyRow: QuickReplyItem {
        var title: String
        var payload: String
    }

    private struct CarouselRow: CarouselItem {
        var title: String
        var imageURL: URL?
        var subtitle: String
        var buttons: [CarouselItemButton]
    }

    private struct VideoRow: VideoItem {
        var url: URL
        var placeholderImage: ImageLoadingKind
        var pictureInPicturePlayingMessage: String
    }

    private struct LinkPreviewRow: LinkPreviewItem {
        var url: URL
        var title: String?
        var description: String?
        var imageURL: URL?
        var host: String?
    }

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

    public struct ChatUserItem: ChatUser, Sendable {
        public static func == (lhs: ChatUserItem, rhs: ChatUserItem) -> Bool {
            lhs.id == rhs.id
        }

        public let id = UUID().uuidString

        /// Username
        public let userName: String

        /// User's chat profile image, considered if `avatarURL` is nil
        public let avatar: PlatformImage?

        /// User's chat profile image URL
        public let avatarURL: URL?

        public init(userName: String, avatarURL: URL? = nil, avatar: PlatformImage? = nil) {
            self.userName = userName
            self.avatar = avatar
            self.avatarURL = avatarURL
        }
    }
}
