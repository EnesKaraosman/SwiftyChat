//
//  User.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import UIKit

public protocol ChatUser: Identifiable, Equatable {

    /// Username
    var userName: String { get }

    /// User's chat profile image, considered if `avatarURL` is nil
    var avatar: UIImage? { get }

    /// User's chat profile image URL
    var avatarURL: URL? { get }

}
