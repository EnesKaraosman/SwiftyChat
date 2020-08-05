//
//  File.swift
//  
//
//  Created by Enes Karaosman on 30.07.2020.
//

import SwiftUI
import KingfisherSwiftUI

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
        avatarImage
            .overlay(
                RoundedRectangle(cornerRadius: currentStyle.cornerRadius)
                    .stroke(
                        currentStyle.borderColor,
                        lineWidth: currentStyle.borderWidth
                    )
                    .shadow(
                        color: currentStyle.shadowColor,
                        radius: currentStyle.shadowRadius
                    )
            )
    }
    
    private var avatarImage: some View {
        Group {
            if user.avatarURL != nil && currentStyle.imageSize.width > 0 {
                KFImage(user.avatarURL)
                    .resizable()
                    .frame(
                        width: currentStyle.imageSize.width,
                        height: currentStyle.imageSize.height
                    )
                    .scaledToFit()
            } else if user.avatar != nil && currentStyle.imageSize.width > 0 {
                Image(uiImage: user.avatar!)
                    .resizable()
                    .frame(
                        width: currentStyle.imageSize.width,
                        height: currentStyle.imageSize.height
                    )
                    .scaledToFit()
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
