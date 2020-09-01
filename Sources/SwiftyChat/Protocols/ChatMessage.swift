//
//  ChatMessage.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import Foundation

public protocol ChatMessage: Identifiable {
    
    var user: ChatUser { get }
    var messageKind: ChatMessageKind { get }
    var isSender: Bool { get }
    var date: Date { get }
    
}
