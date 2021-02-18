//
//  AvatarModifier.swift
//  
//
//  Created by Enes Karaosman on 30.07.2020.
//

import SwiftUI
import Kingfisher

internal struct AvatarModifier<Message: ChatMessage, User: ChatUser>: ViewModifier {
    
    public let message: Message
    @EnvironmentObject var style: ChatMessageCellStyle

    private var isSender: Bool { message.isSender }
    
    private var user: User { message.user as! User }
    
    private var incomingAvatarStyle: AvatarStyle { style.incomingAvatarStyle }
    
    private var outgoingAvatarStyle: AvatarStyle { style.outgoingAvatarStyle }
    
    private var incomingAvatarPosition: AvatarPosition { incomingAvatarStyle.avatarPosition }
    
    private var outgoingAvatarPosition: AvatarPosition { outgoingAvatarStyle.avatarPosition }

    /// Current avatar style
    private var currentStyle: AvatarStyle { isSender ? outgoingAvatarStyle : incomingAvatarStyle }
    
    /// Current avatar position
    private var currentAvatarPosition: AvatarPosition { isSender ? outgoingAvatarPosition : incomingAvatarPosition }
    
    private var alignToMessageBottom: some View {
        VStack {
            Spacer()
            avatar
        }
    }
    
    private var alignToMessageTop: some View {
        VStack {
            avatar
            Spacer()
        }
    }
    
    private var alignToMessageCenter: some View {
        VStack {
            Spacer()
            avatar
            Spacer()
        }
    }
    
    private var avatar: some View {
        let imageStyle = currentStyle.imageStyle
        return avatarImage
            .frame(
                width: imageStyle.imageSize.width,
                height: imageStyle.imageSize.height
            )
            .scaledToFit()
            .cornerRadius(imageStyle.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: imageStyle.cornerRadius)
                    .stroke(
                        imageStyle.borderColor,
                        lineWidth: imageStyle.borderWidth
                    )
                    .shadow(
                        color: imageStyle.shadowColor,
                        radius: imageStyle.shadowRadius
                    )
            )
    }
    
    @ViewBuilder private var avatarImage: some View {
        if let imageURL = user.avatarURL, currentStyle.imageStyle.imageSize.width > 0 {
            KFImage(imageURL).resizable()
        } else if let avatar = user.avatar, currentStyle.imageStyle.imageSize.width > 0 {
            Image(uiImage: avatar).resizable()
        }
    }
    
    @ViewBuilder private var positionedAvatar: some View {
        switch currentAvatarPosition {
        case .alignToMessageTop: alignToMessageTop
        case .alignToMessageCenter: alignToMessageCenter
        case .alignToMessageBottom: alignToMessageBottom
        }
    }
    
    private var avatarSpacing: CGFloat {
        switch currentAvatarPosition {
        case .alignToMessageTop(let spacing): return spacing
        case .alignToMessageCenter(let spacing): return spacing
        case .alignToMessageBottom(let spacing): return spacing
        }
    }
    
    public func body(content: Content) -> some View {
        HStack(spacing: avatarSpacing) {
            if !isSender { positionedAvatar.zIndex(2) }
            content
            if isSender { positionedAvatar.zIndex(2) }
        }
    }
    
}
