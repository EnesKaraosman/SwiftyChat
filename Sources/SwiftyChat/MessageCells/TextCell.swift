//
//  TextCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

internal struct TextCell<Message: ChatMessage>: View {

    public let text: String
    public let message: Message
    public let size: CGSize

    @EnvironmentObject var style: ChatMessageCellStyle

    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }

    private var maxWidth: CGFloat {
        size.width * (Device.isLandscape ? 0.6 : 0.75)
    }

    private var attributedString: AttributedString? {
        try? .init(markdown: text)
    }

    // MARK: - Default Text
    private var defaultText: some View {
        Text(text)
            .applyChatStyle(for: text, cellStyle: cellStyle)
    }

    @ViewBuilder public var body: some View {
        if let attributedString {
            Text(attributedString)
                .applyChatStyle(for: text, cellStyle: cellStyle)
        } else {
            defaultText
        }

    }
}

extension Text {
    func applyChatStyle(for text: String, cellStyle: TextCellStyle) -> some View {
        self
            .font(cellStyle.textStyle.font)
            .fontWeight(cellStyle.textStyle.fontWeight)
            .modifier(EmojiModifier(text: text, defaultFont: cellStyle.textStyle.font))
            .lineLimit(nil)
            .foregroundColor(cellStyle.textStyle.textColor)
            .padding(cellStyle.textPadding)
            .background(cellStyle.cellBackgroundColor)
            .roundedCorners(
                radius: cellStyle.cellCornerRadius,
                corners: cellStyle.cellRoundedCorners
            )
            .overlay(
                RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners)
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
