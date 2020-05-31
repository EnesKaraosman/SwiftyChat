//
//  User.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import UIKit

public struct ChatUser: Identifiable {

    public static func == (lhs: ChatUser, rhs: ChatUser) -> Bool {
        lhs.id == rhs.id
    }

    public var id = UUID()
    public var userName: String
    public var avatar: UIImage?

    public init(userName: String, avatar: UIImage? = nil) {
        self.userName = userName
        self.avatar = avatar
    }
    
}
