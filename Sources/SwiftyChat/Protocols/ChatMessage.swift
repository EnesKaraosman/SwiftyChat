//
//  ChatMessage.swift
//  SwiftyChatbot
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
    var status: SendStatus { get }
    /// The date message sent.
    var date: Date { get }
    
}
