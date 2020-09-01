//
//  User.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import UIKit

//public protocol ChatUser: Identifiable, Equatable {
//
//    /// Username
//    var userName: String { get }
//
//    /// User's chat profile image, considered if `avatarURL` is nil
//    var avatar: UIImage? { get }
//
//    /// User's chat profile image URL
//    var avatarURL: URL? { get }
//
//}

public struct ChatUser: Identifiable, Equatable {

    public static func == (lhs: ChatUser, rhs: ChatUser) -> Bool {
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
