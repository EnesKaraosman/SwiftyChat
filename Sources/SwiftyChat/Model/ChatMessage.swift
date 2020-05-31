//
//  ChatMessage.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import Foundation

public struct ChatMessage: Identifiable {
    
    public let id = UUID()
    public var user: ChatUser
    public var messageKind: ChatMessageKind
    public var isSender: Bool
    public var date: Date
    
    public init(
        user: ChatUser,
        messageKind: ChatMessageKind,
        isSender: Bool = false
        date: Date = .init()
    ) {
        self.user = user
        self.messageKind = messageKind
        self.isSender = isSender
        self.date = date
    }
    
}
