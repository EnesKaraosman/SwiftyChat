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
    
    public let onQuickReplyItemSelected: (QuickReplyItem) -> Void
    public let contactFooterSection: (ContactItem, Message) -> [ContactCellButton]
    public let onTextTappedCallback: () -> AttributedTextTappedCallback
    public let onCarouselItemAction: (CarouselItemButton, Message) -> Void
    public let didTappedMedia: (String) -> Void

    @ViewBuilder private func messageCell() -> some View {
        
        switch message.messageKind {
            
        case .text(let text, let attentions, let priorityLevel):
            TextCell(
                text: text,
                attentions: attentions,
                message: message,
                size: size,
                priortiy: priorityLevel,
                callback: onTextTappedCallback
            )
            
        case .location(let location):
            LocationCell(
                location: location,
                message: message,
                size: size
            )
            
        case .imageText(let imageLoadingType, let text, let attentions, let priorityLevel):
            ImageTextCell(
                message: message,
                attentions: attentions,
                imageLoadingType: imageLoadingType,
                text: text,
                size: size,
                priortiy:priorityLevel
            )
            
        case .image(let imageLoadingType, let priorityLevel):
            ImageCell(
                message: message,
                imageLoadingType: imageLoadingType,
                size: size,
                priortiy: priorityLevel
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
            
        case .video(let videoItem, let priorityLevel):
            VideoPlaceholderCell(
                media: videoItem,
                message: message,
                size: size,
                priortiy: priorityLevel
            )
            
        case .loading:
            LoadingCell(message: message, size: size)
        case .systemMessage(let text):
            SystemMessageCell(text: text,message: message)
        
        case .videoText(let videoItem, let text, let attentions, let priorityLevel):
            SystemMessageCell(text: text,message: message)
            
        case .reply(let reply, let replies, let priorityLevel):
            ReplyCell(message: message,
                      replies: replies,
                      reply: reply,
                      size: size,
                      priortiy: priorityLevel, didTappedMedia: didTappedMedia)
        
        case .pdf(let image, let text, let attentions, let pdfURL, let priorityLevel):
            PdfTextCell(message: message,
                        attentions: attentions,
                        imageLoadingType: image,
                        pdfURL: pdfURL,
                        text: text,
                        size: size,
                        priortiy: priorityLevel)
            
        case .audio(let url, let priorityLevel):
            
           AudioCell(message: message,
                     audioURL: url,
                     size: size,
                     priortiy: priorityLevel)

        }
        
    }
    
    public var body: some View {
            messageCell()
    }
    
}
