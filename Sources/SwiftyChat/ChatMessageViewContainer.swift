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
    let onLinkPreviewTapped: (URL, Message) -> Void
    var onReplyPreviewTapped: ((Message) -> Void)? = nil

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

        case .linkPreview(let linkItem):
            Button {
                onLinkPreviewTapped(linkItem.url, message)
            } label: {
                LinkPreviewMessageView(linkItem: linkItem, message: message, size: size)
            }
            .buttonStyle(.plain)
            .accessibilityLabel([
                linkItem.title,
                linkItem.description,
                linkItem.host ?? linkItem.url.host()
            ].compactMap { $0 }.joined(separator: ". "))

        case .loading:
            LoadingMessageView(message: message, size: size)

        case .custom(let custom):
            if let cell = customCell {
                cell(custom)
            }
        }

    }

    var body: some View {
        VStack(alignment: message.isSender ? .trailing : .leading, spacing: 2) {
            if let reply = message.replyPreview {
                if let onReplyPreviewTapped {
                    Button {
                        onReplyPreviewTapped(message)
                    } label: {
                        replyQuote(reply)
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Go to original message: \(reply.author), \(reply.text)")
                } else {
                    replyQuote(reply)
                }
            }
            messageCell()
        }
    }

    private func replyQuote(_ reply: ChatMessageQuote) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(reply.author)
                .font(.caption.weight(.semibold))
            Text(reply.text)
                .font(.caption)
                .lineLimit(2)
        }
        .foregroundStyle(.primary.opacity(0.75))
        .padding(8)
        .frame(maxWidth: size.width * 0.75, alignment: .leading)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
        .accessibilityElement(children: .combine)
    }
}
