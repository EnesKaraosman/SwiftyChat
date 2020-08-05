//
//  AvatarStyle.swift
//  
//
//  Created by Enes Karaosman on 5.08.2020.
//

import SwiftUI

public enum AvatarPosition {
    case alignToMessageCenter(spacing: CGFloat)
    case alignToMessageTop(spacing: CGFloat)
    case alignToMessageBottom(spacing: CGFloat)
//    case onMessageBottomCorner(spacing: CGFloat)
}

public struct AvatarStyle {
    
    public let imageSize:      CGSize
    public let cornerRadius:   CGFloat
    public let borderColor:    Color
    public let borderWidth:    CGFloat
    public let shadowRadius:   CGFloat
    public let shadowColor:    Color
    public let avatarPosition: AvatarPosition
    
    /// UIKit initializer
    public init(
        imageSize:      CGSize = .init(width: 32, height: 32),
        cornerRadius:   CGFloat = 16,
        borderColor:    UIColor = .systemBlue,
        borderWidth:    CGFloat = 2,
        shadowRadius:   CGFloat = 1,
        shadowColor:    UIColor = .secondaryLabel,
        avatarPosition: AvatarPosition = .alignToMessageBottom(spacing: 8)
    ) {
        self.imageSize = imageSize
        self.cornerRadius = cornerRadius
        self.borderColor = Color(borderColor)
        self.borderWidth = borderWidth
        self.shadowRadius = shadowRadius
        self.shadowColor = Color(shadowColor)
        self.avatarPosition = avatarPosition
    }
    
    /// SwiftUI initializer
    public init(
        imageSize:      CGSize = .init(width: 32, height: 32),
        cornerRadius:   CGFloat = 16,
        borderColor:    Color = .blue,
        borderWidth:    CGFloat = 2,
        shadowRadius:   CGFloat = 1,
        shadowColor:    Color = .secondary,
        avatarPosition: AvatarPosition = .alignToMessageCenter(spacing: 8)
    ) {
        self.imageSize = imageSize
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.avatarPosition = avatarPosition
    }
    
}
