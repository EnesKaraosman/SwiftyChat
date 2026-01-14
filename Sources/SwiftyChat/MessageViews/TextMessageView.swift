//
//  TextMessageView.swift
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

struct TextMessageView<Message: ChatMessage>: View {

    let text: String
    let message: Message
    let size: CGSize

    @EnvironmentObject var style: ChatMessageCellStyle

    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }

    private var maxWidth: CGFloat {
        size.width * (Device.isLandscape ? 0.6 : 0.75)
    }

    // Cache expensive computations
    private let cachedAttributedString: AttributedString?
    private let cachedIsEmojiOnly: Bool
    private let cachedEmojiCount: Int
    
    init(text: String, message: Message, size: CGSize) {
        self.text = text
        self.message = message
        self.size = size
        
        // Compute once during initialization
        self.cachedAttributedString = try? AttributedString(markdown: text)
        self.cachedIsEmojiOnly = text.containsOnlyEmoji
        self.cachedEmojiCount = text.count
    }

    private var defaultText: some View {
        Text(text)
            .applyChatStyle(for: cachedIsEmojiOnly, emojiCount: cachedEmojiCount, cellStyle: cellStyle)
    }

    var body: some View {
        if let cachedAttributedString {
            Text(cachedAttributedString)
                .applyChatStyle(for: cachedIsEmojiOnly, emojiCount: cachedEmojiCount, cellStyle: cellStyle)
        } else {
            defaultText
        }
    }
}

private extension Text {
    func applyChatStyle(for isEmojiOnly: Bool, emojiCount: Int, cellStyle: TextCellStyle) -> some View {
        self
            .font(cellStyle.textStyle.font)
            .fontWeight(cellStyle.textStyle.fontWeight)
            .modifier(EmojiModifier(isEmojiOnly: isEmojiOnly, emojiCount: emojiCount, defaultFont: cellStyle.textStyle.font))
            .lineLimit(nil)
            .foregroundColor(cellStyle.textStyle.textColor)
            .fixedSize(horizontal: false, vertical: true)
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
