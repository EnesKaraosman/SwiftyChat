//
//  File.swift
//  
//
//  Created by Enes Karaosman on 30.07.2020.
//

import SwiftUI
import KingfisherSwiftUI

public enum AvatarPosition {
    case onLeftBottom(spacing: CGFloat)
    case onLeftMid(spacing: CGFloat)
    case onLeftTop(spacing: CGFloat)
    case onRightBottom(spacing: CGFloat)
    case onRightMid(spacing: CGFloat)
    case onRightTop(spacing: CGFloat)
}

public struct AvatarModifier: ViewModifier {
    
    public var isSender: Bool
    public var user: ChatUser = ChatUser(
        userName: "Enes",
        avatarURL: URL(string: "https://3.bp.blogspot.com/-vO7C5BPCaCQ/WigyjG6Q8lI/AAAAAAAAfyQ/1tobZMMwZ2YEI0zx5De7kD31znbUAth0gCLcBGAs/s200/TOMI_avatar_full.png")
    )
    public var incomingAvatarPosition: AvatarPosition = .onLeftBottom(spacing: 8)
    public var outgoingAvatarPosition: AvatarPosition = .onRightTop(spacing: 8)
    
    private var onSideBottom: some View {
        VStack {
            Spacer()
            avatar
        }
    }
    
    private var onSideTop: some View {
        VStack {
            avatar
            Spacer()
        }
    }
    
    private var onSideMid: some View {
        VStack {
            Spacer()
            avatar
            Spacer()
        }
    }
    
    private var avatar: some View {
        avatarImage
            .overlay(
                Circle()
                    .stroke(Color.red, lineWidth: 2)
            )
    }
    
    private var avatarImage: some View {
        Group {
            if user.avatarURL != nil {
                KFImage(user.avatarURL)
                    .resizable()
                    .frame(width: 40, height: 40)
            } else if user.avatar != nil {
                Image(uiImage: user.avatar!)
                    .resizable()
                    .frame(width: 40, height: 40)
            } else {
                EmptyView()
            }
        }
    }
    
    private var positionedAvatar: some View {
        let position = isSender ? self.outgoingAvatarPosition : self.incomingAvatarPosition
        switch position {
        case .onLeftTop: return onSideTop.embedInAnyView()
        case .onLeftMid: return onSideMid.embedInAnyView()
        case .onLeftBottom: return onSideBottom.embedInAnyView()
        case .onRightTop: return onSideTop.embedInAnyView()
        case .onRightMid: return onSideMid.embedInAnyView()
        case .onRightBottom: return onSideBottom.embedInAnyView()
        }
    }
    
    private var avatarSpacing: CGFloat {
        let position = isSender ? self.outgoingAvatarPosition : self.incomingAvatarPosition
        switch position {
        case .onLeftTop(let spacing): return spacing
        case .onLeftMid(let spacing): return spacing
        case .onLeftBottom(let spacing): return spacing
        case .onRightTop(let spacing): return spacing
        case .onRightMid(let spacing): return spacing
        case .onRightBottom(let spacing): return spacing
        }
    }
    
    public func body(content: Content) -> some View {
        Group {
            if !isSender {
                HStack(spacing: avatarSpacing) {
                    positionedAvatar.zIndex(2)
                    content
                }
            } else {
                HStack(spacing: avatarSpacing) {
                    content
                    positionedAvatar.zIndex(2)
                }
            }
        }
    }
    
}
