//
//  TextMessageView.swift
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import Foundation
import SwiftUI

struct TextMessageView<Message: ChatMessage>: View {

    let text: String
    let message: Message
    let size: CGSize

    @Environment(\.chatStyle) var style

    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }

    private var maxWidth: CGFloat {
        size.width * (Device.isLandscape ? 0.6 : 0.75)
    }

    private let cachedIsEmojiOnly: Bool
    private let cachedEmojiCount: Int

    /// Pre-parsed attributed string with markdown + auto-detected links.
    /// Computed once in `init` since it only depends on the `text` value.
    /// The cheap style-merge (font, color) still happens in `body` because
    /// it reads from `@Environment`.
    private let cachedParsedString: AttributedString?

    init(text: String, message: Message, size: CGSize) {
        self.text = text
        self.message = message
        self.size = size
        self.cachedIsEmojiOnly = text.containsOnlyEmoji
        self.cachedEmojiCount = text.count
        self.cachedParsedString = Self.parseText(text)
    }

    /// Parses the text as Markdown and auto-detects links / phone numbers /
    /// addresses via `NSDataDetector`. This is the expensive part and is
    /// cached in `init`.
    private static func parseText(_ text: String) -> AttributedString? {
        guard var result = try? AttributedString(
            markdown: text,
            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        ) else { return nil }

        applyDataDetectorLinks(to: &result, in: text)
        return result
    }

    /// Applies the cell style's base font and color to the pre-parsed
    /// attributed string and underlines links. This is cheap and safe to
    /// call from `body`.
    private func applyStyle(to source: AttributedString) -> AttributedString {
        var result = source

        var base = AttributeContainer()
        base.font = cellStyle.textStyle.font
        base.foregroundColor = cellStyle.textStyle.textColor
        result.mergeAttributes(base, mergePolicy: .keepCurrent)

        // Underline any run that carries a link so it looks tappable.
        for run in result.runs where run.link != nil {
            result[run.range].underlineStyle = .single
        }

        return result
    }

    /// Uses `NSDataDetector` to find URLs, phone numbers, and addresses in
    /// `plainText` and sets `.link` attributes on the corresponding ranges of
    /// `attributed`. Ranges that already carry a link (from the markdown
    /// parser) are skipped.
    private static func applyDataDetectorLinks(
        to attributed: inout AttributedString,
        in plainText: String
    ) {
        let types: NSTextCheckingResult.CheckingType = [.link, .phoneNumber, .address]
        guard let detector = try? NSDataDetector(types: types.rawValue) else { return }

        let nsString = plainText as NSString
        let matches = detector.matches(
            in: plainText,
            range: NSRange(location: 0, length: nsString.length)
        )

        for match in matches {
            guard let swiftRange = Range(match.range, in: plainText),
                  let attrRange = Range(swiftRange, in: attributed) else { continue }

            // Skip if the markdown parser already set a link here.
            if attributed[attrRange].link != nil { continue }

            let url: URL? = if let matchURL = match.url {
                matchURL
            } else if match.resultType == .phoneNumber, let phone = match.phoneNumber {
                URL(string: "tel:\(phone.filter { $0.isNumber || $0 == "+" })")
            } else {
                nil
            }

            if let url {
                attributed[attrRange].link = url
            }
        }
    }

    var body: some View {
        if cachedIsEmojiOnly {
            Text(text)
                .font(cellStyle.textStyle.font)
                .fontWeight(cellStyle.textStyle.fontWeight)
                .modifier(EmojiModifier(isEmojiOnly: true, emojiCount: cachedEmojiCount, defaultFont: cellStyle.textStyle.font))
                .lineLimit(nil)
                .foregroundStyle(cellStyle.textStyle.textColor)
                .fixedSize(horizontal: false, vertical: true)
                .cellContainer(cellStyle: cellStyle)
        } else if let parsed = cachedParsedString {
            Text(applyStyle(to: parsed))
                .fontWeight(cellStyle.textStyle.fontWeight)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .cellContainer(cellStyle: cellStyle)
        } else {
            Text(text)
                .font(cellStyle.textStyle.font)
                .fontWeight(cellStyle.textStyle.fontWeight)
                .lineLimit(nil)
                .foregroundStyle(cellStyle.textStyle.textColor)
                .fixedSize(horizontal: false, vertical: true)
                .cellContainer(cellStyle: cellStyle)
        }
    }
}

private extension View {
    /// Applies the bubble container styling (padding, background, rounded
    /// corners, border, shadow) without setting text-level attributes.
    func cellContainer(cellStyle: TextCellStyle) -> some View {
        self
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
