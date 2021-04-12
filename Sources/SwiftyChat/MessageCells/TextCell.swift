//
//  TextCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public struct TextCell: View {
    
    public let text: String
    public let message: ChatMessage
    public let size: CGSize
    public let callback: () -> AttributedTextTappedCallback
    
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }
    
    private var maxWidth: CGFloat {
        size.width * (UIDevice.isLandscape ? 0.6 : 0.75)
    }
    
    private var action: AttributedTextTappedCallback {
        return callback()
    }
    
    // MARK: - Default Text
    private var defaultText: some View {
        Text(text)
            .fontWeight(cellStyle.textStyle.fontWeight)
            .modifier(EmojiModifier(text: text, defaultFont: cellStyle.textStyle.font))
            .lineLimit(nil)
            .foregroundColor(cellStyle.textStyle.textColor)
            .padding([.leading, .trailing], cellStyle.textHorizontalPadding)
            .padding([.top, .bottom], cellStyle.textVerticalPadding)
            .background(cellStyle.cellBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cellStyle.cellCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cellStyle.cellCornerRadius)
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
    
    private var attributedText: some View {
        let textStyle = cellStyle.attributedTextStyle
        
        return AttributedText(text: text, width: maxWidth) {
            
            $0.enabledDetectors = textStyle.enabledDetectors
            $0.didSelectAddress = self.action.didSelectAddress
            $0.didSelectDate = self.action.didSelectDate
            $0.didSelectPhoneNumber = self.action.didSelectPhoneNumber
            $0.didSelectURL = self.action.didSelectURL
            $0.didSelectTransitInformation = self.action.didSelectTransitInformation
            //            $0.didSelectMention = self.action.didSelectMention
            //            $0.didSelectHashtag = self.action.didSelectHashtag
            
            $0.font = textStyle.font.withWeight(textStyle.fontWeight)
            $0.textColor = textStyle.textColor
            $0.setAttributes([
                NSAttributedString.Key.foregroundColor: textStyle.tintColor,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.underlineColor: textStyle.tintColor
            ], detector: .url)
            $0.textAlignment = self.message.isSender ? .right : .left
        }
        .padding([.leading, .trailing], cellStyle.textHorizontalPadding)
        .padding([.top, .bottom], cellStyle.textVerticalPadding)
        .background(cellStyle.cellBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cellStyle.cellCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cellStyle.cellCornerRadius)
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
    
    public var body: some View {
        Group {
            if AttributeDetective(
                text: text,
                enabledDetectors: cellStyle.attributedTextStyle.enabledDetectors
            ).doesContain() || text.containsHtml() {
                self.attributedText
            } else {
                self.defaultText
            }
        }
    }
    
}
