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
    
    public let onQuickReplyItemSelected: (QuickReplyItem) -> Void
    public let contactFooterSection: (ContactItem, ChatMessage) -> [ContactCellButton]
    public let onTextTappedCallback: () -> AttributedTextTappedCallback
    public let onCarouselItemAction: (CarouselItemButton, ChatMessage) -> Void
    
    func messageCell() -> some View {
        switch message.messageKind {
            
        case .text(let text):
            
            return TextCell(
                text: text,
                message: message,
                callback: onTextTappedCallback
            ).embedInAnyView()
            
        case .location(let location):
            
            return LocationCell(
                location: location,
                message: message
            ).embedInAnyView()
            
        case .image(let imageLoadingType):
            
            return ImageCell(
                message: message,
                imageLoadingType: imageLoadingType
            ).embedInAnyView()
            
        case .contact(let contact):
            
            return ContactCell(
                contact: contact,
                message: message,
                footerSection: contactFooterSection
            ).embedInAnyView()
            
        case .quickReply(let quickReplies):
            return QuickReplyCell(
                quickReplies: quickReplies,
                quickReplySelected: onQuickReplyItemSelected
            ).embedInAnyView()
            
        case .carousel(let carouselItems):
            return CarouselCell(
                carouselItems: carouselItems,
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
