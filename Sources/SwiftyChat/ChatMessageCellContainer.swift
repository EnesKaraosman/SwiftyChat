//
//  MessageCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

internal struct ChatMessageCellContainer<Message: ChatMessage>: View {
    
    public let message: Message
    public let size: CGSize
    
    public let customCell: ((Any) -> AnyView)?
    public let onQuickReplyItemSelected: (QuickReplyItem) -> Void
    public let contactFooterSection: (ContactItem, Message) -> [ContactCellButton]
    public let onTextTappedCallback: () -> AttributedTextTappedCallback
    public let onCarouselItemAction: (CarouselItemButton, Message) -> Void
    
    @ViewBuilder private func messageCell() -> some View {
        switch message.messageKind {
            
        case .text(let text):
            TextCell(
                text: text,
                message: message,
                size: size,
                callback: onTextTappedCallback
            )
            
        case .location(let location):
            LocationCell(
                location: location,
                message: message,
                size: size
            )
            
        case .imageText(let imageLoadingType, let text):
            ImageTextCell(
                message: message,
                imageLoadingType: imageLoadingType,
                text: text,
                size: size
            )
            
        case .image(let imageLoadingType):
            ImageCell(
                message: message,
                imageLoadingType: imageLoadingType,
                size: size
            )
            
        case .contact(let contact):
            ContactCell(
                contact: contact,
                message: message,
                size: size,
                footerSection: contactFooterSection
            )
            
        case .quickReply(let quickReplies):
            QuickReplyCell(
                quickReplies: quickReplies,
                quickReplySelected: onQuickReplyItemSelected
            )
            
        case .carousel(let carouselItems):
            CarouselCell(
                carouselItems: carouselItems,
                size: size,
                message: message,
                onCarouselItemAction: onCarouselItemAction
            )
            
        case .video(let videoItem):
            VideoPlaceholderCell(
                media: videoItem,
                message: message,
                size: size
            )
            
        case .loading:
            LoadingCell(message: message, size: size)
            
        case .custom(let custom):
            if let cell = customCell {
                cell(custom)
            }
        }
        
    }
    
    public var body: some View {
        messageCell()
    }
    
}
