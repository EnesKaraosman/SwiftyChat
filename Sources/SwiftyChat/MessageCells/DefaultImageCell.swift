//
//  DefaultImageCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 23.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

public struct DefaultImageCell: View {
    
    public let message: ChatMessage
    public let imageLoadingType: ImageLoadingKind
    public let proxy: GeometryProxy
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var imageWidth: CGFloat {
        proxy.size.width * (UIDevice.isLandscape ? 0.4 : 0.8)
    }
    
    private var imageView: AnyView {
        switch imageLoadingType {
        case .local(let image):
            return self.localImage(uiImage: image)
        case .remote(let remoteUrl):
            return self.remoteImage(url: remoteUrl)
        }
    }
    
    public var body: some View {
        imageView
    }
    
    // MARK: - case Local Image
    private func localImage(uiImage: UIImage) -> AnyView {
        let isLandscape = uiImage.size.width > uiImage.size.height
        return Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: isLandscape ? .fit : .fill)
            .frame(width: imageWidth, height: isLandscape ? nil : imageWidth)
            .cornerRadius(message.isSender ? style.incomingCornerRadius : style.outgoingCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: message.isSender ? style.incomingCornerRadius : style.outgoingCornerRadius)
                    .stroke(
                        message.isSender ? style.incomingBorderColor : style.outgoingBorderColor,
                        lineWidth: message.isSender ? style.incomingBorderWidth : style.outgoingBorderWidth
                )
            )
            .shadow(
                color: message.isSender ? style.incomingShadowColor : style.outgoingShadowColor,
                radius: message.isSender ? style.incomingShadowRadius : style.outgoingShadowRadius
            )
            .embedInAnyView()
    }
    
    // MARK: - case Remote Image
    private func remoteImage(url: URL) -> AnyView {
        
        return KFImage(url)
            .resizable()
            .scaledToFit()
            .frame(width: imageWidth)
            .cornerRadius(message.isSender ? style.incomingCornerRadius : style.outgoingCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: message.isSender ? style.incomingCornerRadius : style.outgoingCornerRadius)
                    .stroke(
                        message.isSender ? style.incomingBorderColor : style.outgoingBorderColor,
                        lineWidth: message.isSender ? style.incomingBorderWidth : style.outgoingBorderWidth
                )
            )
            .shadow(
                color: message.isSender ? style.incomingShadowColor : style.outgoingShadowColor,
                radius: message.isSender ? style.incomingShadowRadius : style.outgoingShadowRadius
            )
            .embedInAnyView()
        
    }
    
}

