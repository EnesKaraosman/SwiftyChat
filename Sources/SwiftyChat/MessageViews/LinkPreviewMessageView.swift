//
//  LinkPreviewMessageView.swift
//
//  Created on 2026-04-06.
//

import Kingfisher
import SwiftUI

struct LinkPreviewMessageView<Message: ChatMessage>: View {

    let linkItem: LinkPreviewItem
    let message: Message
    let size: CGSize

    @Environment(\.chatStyle) var style

    private var cellStyle: LinkPreviewCellStyle {
        style.linkPreviewCellStyle
    }

    private var cellWidth: CGFloat {
        cellStyle.cellWidth(size)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let imageURL = linkItem.imageURL {
                KFImage.url(imageURL)
                    .cacheOriginalImage()
                    .fade(duration: 0.2)
                    .placeholder { _ in
                        Rectangle()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(width: cellWidth, height: cellStyle.imageHeight)
                            .overlay(ProgressView())
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: cellWidth, height: cellStyle.imageHeight)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 4) {
                if let title = linkItem.title {
                    Text(title)
                        .font(cellStyle.titleStyle.font)
                        .fontWeight(cellStyle.titleStyle.fontWeight)
                        .foregroundStyle(cellStyle.titleStyle.textColor)
                        .lineLimit(2)
                }

                if let description = linkItem.description {
                    Text(description)
                        .font(cellStyle.descriptionStyle.font)
                        .fontWeight(cellStyle.descriptionStyle.fontWeight)
                        .foregroundStyle(cellStyle.descriptionStyle.textColor)
                        .lineLimit(3)
                }

                Text(linkItem.host ?? linkItem.url.host() ?? linkItem.url.absoluteString)
                    .font(cellStyle.hostStyle.font)
                    .fontWeight(cellStyle.hostStyle.fontWeight)
                    .foregroundStyle(cellStyle.hostStyle.textColor)
                    .lineLimit(1)
            }
            .padding(cellStyle.textPadding)
        }
        .frame(width: cellWidth)
        .background(cellStyle.cellBackgroundColor)
        .roundedCorners(
            radius: cellStyle.cellCornerRadius,
            corners: cellStyle.cellRoundedCorners
        )
        .overlay(
            RoundedCornerShape(
                radius: cellStyle.cellCornerRadius,
                corners: cellStyle.cellRoundedCorners
            )
            .stroke(
                cellStyle.cellBorderColor,
                lineWidth: cellStyle.cellBorderWidth
            )
            .shadow(
                color: cellStyle.cellShadowColor,
                radius: cellStyle.cellShadowRadius
            )
        )
    }
}
