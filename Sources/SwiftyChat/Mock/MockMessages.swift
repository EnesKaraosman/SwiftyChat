//
//  MockMessages.swift
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

// swiftlint:disable identifier_name

import Foundation

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
            case .Video: return .video(
                VideoRow(
                    url: URL(string: "")!,
                    placeholderImage: .remote(URL(string: "")!),
                    pictureInPicturePlayingMessage: ""
                )
            )
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
        var image: PlatformImage?
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
        public var avatar: PlatformImage?

        /// User's chat profile image URL
        public var avatarURL: URL?

        public init(userName: String, avatarURL: URL? = nil, avatar: PlatformImage? = nil) {
            self.userName = userName
            self.avatar = avatar
            self.avatarURL = avatarURL
        }

    }

    public static var sender: ChatUserItem = .init(
        userName: "Sender",
        avatarURL: URL(string: "https://leafac.github.io/fake-avatars/avatars/png/\(Int.random(in: 1...250)).png")
    )

    public static var chatbot: ChatUserItem = .init(
        userName: "Chatbot",
        avatarURL: URL(string: "https://leafac.github.io/fake-avatars/avatars/png/\(Int.random(in: 1...250)).png")
    )

    private static var randomUser: ChatUserItem {
        [sender, chatbot].randomElement()!
    }

    public static var mockImages: [PlatformImage] = []

    public static func generateMessage(kind: MockMessages.Kind, count: UInt) -> [ChatMessageItem] {
        (1...count).map { _ in generateMessage(kind: kind) }
    }

    public static func generateMessage(kind: MockMessages.Kind) -> ChatMessageItem {
        let randomUser = Self.randomUser

        switch kind {

        case .Image:
            let randomId = Int.random(in: 1...100)
            guard let url = URL(string: "https://picsum.photos/id/\(randomId)/800/600") else {
                fallthrough
            }

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
                ContactRow(displayName: "John Doe"),
                ContactRow(displayName: "Serdar Bale")
            ]
            return ChatMessageItem(
                user: randomUser,
                messageKind: .contact(contacts.randomElement()!),
                isSender: randomUser == Self.sender
            )

        case .Video:
            let videoItem = VideoRow(
                url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
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
                messageKind: .custom("Custom Message Kind 😍🥰"),
                isSender: randomUser == Self.sender
            )
        }
    }

    public static var randomMessageKind: MockMessages.Kind {
        return [
            .Image,
            .Text, .Text,
            .Image,
            .Text, .Text,
            .Contact,
            .Text, .Text,
            .Carousel,
            .Text, .Text,
            .Location,
            .Text, .Text,
            .Video,
            .Text, .Text,
            .QuickReply,
            .Custom
        ].randomElement()!
    }

    public static func generatedMessages(count: Int = 30) -> [ChatMessageItem] {
        (1...count).map { _ in generateMessage(kind: randomMessageKind)}
    }
}
