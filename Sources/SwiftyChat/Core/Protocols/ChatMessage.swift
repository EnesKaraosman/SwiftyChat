//
//  ChatMessage.swift
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import Foundation

public protocol ChatMessage: Identifiable {

    associatedtype User: ChatUser

    /// The `User` who sent this message.
    var user: User { get }

    /// Type of message
    var messageKind: ChatMessageKind { get }

    /// To determine if user is the current user to properly align UI.
    var isSender: Bool { get }

    /// The date message sent.
    var date: Date { get }

    var replyPreview: ChatMessageQuote? { get }

    var deliveryStatus: MessageDeliveryStatus? { get }
}

public extension ChatMessage {
    var replyPreview: ChatMessageQuote? { nil }
    var deliveryStatus: MessageDeliveryStatus? { nil }
}

public struct ChatMessageQuote: Equatable, Sendable {
    public let author: String
    public let text: String

    public init(author: String, text: String) {
        self.author = author
        self.text = text
    }
}

public enum MessageDeliveryStatus: String, Sendable {
    case sending
    case sent
    case delivered
    case read
    case failed
}
