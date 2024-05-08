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
    public let didTappedViewTask: (Message) -> Void

    @ViewBuilder private func messageCell() -> some View {
        
        switch message.messageKind {
            
        case .text(let text, let attentions, let priorityLevel, let actionStatus):
            TextCell(
                text: text,
                attentions: attentions,
                message: message,
                size: size,
                priority: priorityLevel,
                actionStatus:actionStatus,
                callback: onTextTappedCallback,
                didTappedViewTask: didTappedViewTask
            )
            
        case .location(let location):
            LocationCell(
                location: location,
                message: message,
                size: size
            )
            
        case .imageText(let imageLoadingType, let text, let attentions, let priorityLevel, let actionStatus):
            ImageTextCell(
                message: message,
                attentions: attentions,
                imageLoadingType: imageLoadingType,
                text: text,
                size: size,
                priority:priorityLevel,
                actionStatus:actionStatus,
                didTappedViewTask : didTappedViewTask
            )
            
        case .image(let imageLoadingType, let priorityLevel, let actionStatus):
            ImageCell(
                message: message,
                imageLoadingType: imageLoadingType,
                size: size,
                priority: priorityLevel,
                actionStatus: actionStatus,
                didTappedViewTask : didTappedViewTask
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
            
        case .video(let videoItem, let priorityLevel, let actionStatus):
            VideoPlaceholderCell(
                media: videoItem,
                message: message,
                size: size,
                priority: priorityLevel,
                actionStatus : actionStatus,
                didTappedViewTask : didTappedViewTask
            )
            
        case .loading:
            LoadingCell(message: message, size: size)
        case .systemMessage(let text):
            SystemMessageCell(text: text,message: message)
        
        case .videoText(let videoItem, let text, let attentions, let priorityLevel, let actionStatus):
            SystemMessageCell(text: text,message: message)
            
        case .reply(let reply, let replies, let priorityLevel, let actionStatus):
            ReplyCell(message: message,
                      replies: replies,
                      reply: reply,
                      size: size,
                      priority: priorityLevel,
                      actionStatus : actionStatus,
                      didTappedMedia: didTappedMedia,
                      didTappedViewTask : didTappedViewTask)
        
        case .pdf(let image, let text, let attentions, let pdfURL, let priorityLevel, let actionStatus):
            PdfTextCell(message: message,
                        attentions: attentions,
                        imageLoadingType: image,
                        pdfURL: pdfURL,
                        text: text,
                        size: size,
                        priority: priorityLevel,
                        actionStatus : actionStatus,
                        didTappedViewTask : didTappedViewTask)
            
        case .audio(let url, let priorityLevel, let actionStatus):
            
           AudioCell(message: message,
                     audioURL: url,
                     size: size,
                     priority: priorityLevel,
                     actionStatus:actionStatus,
                     didTappedViewTask:didTappedViewTask)

        }
        
    }
    
    public var body: some View {
            messageCell()
    }
    
}
