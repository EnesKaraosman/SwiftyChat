//
//  File.swift
//  
//
//  Created by Enes Karaosman on 30.07.2020.
//

import SwiftUI

public struct AvatarModifier: ViewModifier {
    
    public let message: ChatMessage
    @EnvironmentObject var style: ChatMessageCellStyle

    private var isSender: Bool { message.isSender }
    
    private var user: ChatUser { message.user }
    
    private var incomingAvatarStyle: AvatarStyle { style.incomingAvatarStyle }
    
    private var outgoingAvatarStyle: AvatarStyle { style.outgoingAvatarStyle }
    
    private var incomingAvatarPosition: AvatarPosition { incomingAvatarStyle.avatarPosition }
    
    private var outgoingAvatarPosition: AvatarPosition { outgoingAvatarStyle.avatarPosition }

    /// Current avatar style
    private var currentStyle: AvatarStyle { isSender ? outgoingAvatarStyle : incomingAvatarStyle }
    
    /// Current avatar position
    private var currentAvatarPosition: AvatarPosition { isSender ? outgoingAvatarPosition : incomingAvatarPosition }
    
    private var onMessageBottom: some View {
        VStack {
            Spacer()
            avatar
        }
    }
    
    private var onMessageTop: some View {
        VStack {
            avatar
            Spacer()
        }
    }
    
    private var onMessageCenter: some View {
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
    
    private var avatarImage: some View {
        Group {
            if user.avatarURL != nil && currentStyle.imageStyle.imageSize.width > 0 {
                Image(uiImage: .checkmark).resizable()
            } else if user.avatar != nil && currentStyle.imageStyle.imageSize.width > 0 {
                Image(uiImage: user.avatar!).resizable()
            } else {
                EmptyView()
            }
        }
    }
    
    private var positionedAvatar: some View {
        switch currentAvatarPosition {
        case .alignToMessageTop: return onMessageTop.embedInAnyView()
        case .alignToMessageCenter: return onMessageCenter.embedInAnyView()
        case .alignToMessageBottom: return onMessageBottom.embedInAnyView()
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
            if !isSender {
                positionedAvatar.zIndex(2)
            }
            content
            if isSender {
                positionedAvatar.zIndex(2)
            }
        }
    }
    
}
