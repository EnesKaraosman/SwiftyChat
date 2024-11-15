//
//  ChatMessageViewContainer.swift
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

struct ChatMessageViewContainer<Message: ChatMessage>: View {

    let message: Message
    let size: CGSize
    let customCell: ((Any) -> AnyView)?
    let onQuickReplyItemSelected: (QuickReplyItem) -> Void
    let contactFooterSection: (ContactItem, Message) -> [ContactCellButton]
    let onCarouselItemAction: (CarouselItemButton, Message) -> Void

    @ViewBuilder
    private func messageCell() -> some View {
        switch message.messageKind {

        case .text(let text):
            TextMessageView(text: text, message: message, size: size)

        case .location(let location):
            LocationMessageView(location: location, message: message, size: size)

        case .imageText(let imageLoadingType, let text):
            ImageTextMessageView(
                message: message,
                imageLoadingType: imageLoadingType,
                text: text,
                size: size
            )

        case .image(let imageLoadingType):
            ImageMessageView(
                message: message,
                imageLoadingType: imageLoadingType,
                size: size
            )

        case .contact(let contact):
            ContactMessageView(
                contact: contact,
                message: message,
                size: size,
                footerSection: contactFooterSection
            )

        case .quickReply(let quickReplies):
            QuickReplyMessageView(
                quickReplies: quickReplies,
                quickReplySelected: onQuickReplyItemSelected
            )

        case .carousel(let carouselItems):
            CarouselMessageView(
                carouselItems: carouselItems,
                size: size,
                message: message,
                onCarouselItemAction: onCarouselItemAction
            )

        case .video(let videoItem):
            VideoMessageView(media: videoItem, message: message, size: size)

        case .loading:
            LoadingMessageView(message: message, size: size)

        case .custom(let custom):
            if let cell = customCell {
                cell(custom)
            }
        }

    }

    var body: some View {
        messageCell()
    }
}
