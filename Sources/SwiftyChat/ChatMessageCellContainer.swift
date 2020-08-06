//
//  MessageCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public struct ChatMessageCellContainer: View {
    
    public let message: ChatMessage
    public let size: CGSize
    
    public let onQuickReplyItemSelected: (QuickReplyItem) -> Void
    public let contactFooterSection: (ContactItem, ChatMessage) -> [ContactCellButton]
    public let onTextTappedCallback: () -> TextTappedCallback
    public let onCarouselItemAction: (URL?, ChatMessage) -> Void
    
    func messageCell() -> some View {
        switch message.messageKind {
            
        case .text(let text):
            
            return DefaultTextCell(
                text: text,
                message: message,
                size: size,
                callback: onTextTappedCallback
            ).embedInAnyView()
            
        case .location(let location):
            
            return DefaultLocationCell(
                location: location,
                message: message,
                size: size
            ).embedInAnyView()
            
        case .image(let imageLoadingType):
            
            return DefaultImageCell(
                message: message,
                imageLoadingType: imageLoadingType,
                size: size
            ).embedInAnyView()
            
        case .contact(let contact):
            
            return DefaultContactCell(
                contact: contact,
                message: message,
                size: size,
                footerSection: contactFooterSection
            ).embedInAnyView()
            
        case .quickReply(let quickReplies):
            return QuickReplyCell(
                quickReplies: quickReplies,
                quickReplySelected: onQuickReplyItemSelected
            ).embedInAnyView()
            
        case .carousel(let carouselItems):
            return DefaultCarouselCell(
                carouselItems: carouselItems,
                size: size,
                message: message,
                onCarouselItemAction: onCarouselItemAction
            )
            .embedInAnyView()
            
        }
        
    }
    
    public var body: some View {
        messageCell()
    }
    
}
