//
//  MessageCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

internal struct ChatMessageCellContainer<Message: ChatMessage>: View {

    let message: Message
    let size: CGSize
    let customCell: ((Any) -> AnyView)?
    let onQuickReplyItemSelected: (QuickReplyItem) -> Void
    let contactFooterSection: (ContactItem, Message) -> [ContactCellButton]
    let onCarouselItemAction: (CarouselItemButton, Message) -> Void

    @ViewBuilder private func messageCell() -> some View {
        switch message.messageKind {

        case .text(let text):
            TextCell(
                text: text,
                message: message,
                size: size
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

    var body: some View {
        messageCell()
    }
}
