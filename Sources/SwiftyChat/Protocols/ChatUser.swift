//
//  User.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

#if os(iOS)
import UIKit

public typealias PlatformImage = UIImage
#endif

#if os(macOS)
import AppKit

public typealias PlatformImage = NSImage
#endif

public protocol ChatUser: Identifiable, Equatable {

    /// Username
    var userName: String { get }

    /// User's chat profile image, considered if `avatarURL` is nil
    var avatar: PlatformImage? { get }

    /// User's chat profile image URL
    var avatarURL: URL? { get }
}
