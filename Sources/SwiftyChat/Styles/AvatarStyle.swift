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
}

public struct AvatarStyle {

    public let imageStyle: CommonImageStyle
    public let avatarPosition: AvatarPosition

    public init(
        imageStyle: CommonImageStyle = CommonImageStyle(),
        avatarPosition: AvatarPosition = .alignToMessageCenter(spacing: 8)
    ) {
        self.imageStyle = imageStyle
        self.avatarPosition = avatarPosition
    }
}
