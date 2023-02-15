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
    public let callback: () -> AttributedTextTappedCallback
    
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }
    
    private let enabledDetectors: [DetectorType] = [
        .address, .date, .phoneNumber, .url, .transitInformation
    ]
    
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
            .padding(cellStyle.textPadding)
            .background(cellStyle.cellBackgroundColor)
            .clipShape(RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners)
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
    
    private var attributedText: some View {
        let textStyle = cellStyle.attributedTextStyle
        
        let attributes = AZTextFrameAttributes(
            string: text,
            width: maxWidth,
            font: cellStyle.attributedTextStyle.font
        )

        let textHeight = attributes.calculatedTextHeight()
        
        let frame = text.frameSize(maxWidth: maxWidth, maxHeight: nil)
        let textWidth = frame.width
        
        MessageLabel.defaultAttributes[.foregroundColor] = textStyle.textColor
        MessageLabel.defaultAttributes[.underlineColor] = textStyle.textColor
        
        return AttributedTextCell(text: text, width: maxWidth) {
            
            $0.enabledDetectors = enabledDetectors
            $0.didSelectAddress = action.didSelectAddress
            $0.didSelectDate = action.didSelectDate
            $0.didSelectPhoneNumber = action.didSelectPhoneNumber
            $0.didSelectURL = action.didSelectURL
            $0.didSelectTransitInformation = action.didSelectTransitInformation
            //            $0.didSelectMention = self.action.didSelectMention
            //            $0.didSelectHashtag = self.action.didSelectHashtag
            
            $0.font = textStyle.font.withWeight(textStyle.fontWeight)
            $0.textColor = textStyle.textColor
            $0.textAlignment = message.isSender ? .right : .left
        }
        .frame(width: textWidth, height: textHeight)
        .padding(cellStyle.textPadding)
        .background(cellStyle.cellBackgroundColor)
        .clipShape(RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners))
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
    
    @ViewBuilder public var body: some View {
//        if text.containsHtml() ||
//            AttributeDetective(
//                text: text,
//                enabledDetectors: enabledDetectors
//            ).doesContain()
//        {
//            attributedText
//        } else {
//            defaultText
//        }
        defaultText
    }
    
}
