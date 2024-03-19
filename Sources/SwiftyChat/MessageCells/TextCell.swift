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
    public let attentions : [String]?
    public let message: Message
    public let size: CGSize
    public let priortiy: MessagePriorityLevel
    public let callback: () -> AttributedTextTappedCallback
    
    @State private var showFullText = false

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
    
    private var showMore : some View {
            HStack {
                Spacer()
                Button(action: {
                    showFullText.toggle() // Toggle between showing full text a     nd truncated text
                }) {
                    Text(showFullText ? "Show less" : "Show more")
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                }
                .padding(.trailing)
                .padding(.bottom)
            }
    }
    
    // MARK: - Default Text
    private var defaultText: some View {
        
        VStack(alignment: .leading) {
            Text(text)
                .fontWeight(cellStyle.textStyle.fontWeight)
                .lineLimit(showFullText ? nil : 20)
                .modifier(EmojiModifier(text: text, defaultFont: cellStyle.textStyle.font))
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(cellStyle.textStyle.textColor)
                .padding(cellStyle.textPadding)

            
            if self.computeLineCount(for: text, with: cellStyle) > 20 {
                showMore
            }

            if priortiy == .high || priortiy == .medium {
                PriorityMessageViewStyle(priorityLevel: priortiy)
                    .padding(.bottom,10)
                    .padding(.leading,10)
                    .frame(alignment: .leading)
                    .shadow (
                        color: cellStyle.cellShadowColor,
                        radius: cellStyle.cellShadowRadius
                    )
            }
        }
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
 
    
    private func computeLineCount(for text: String, with style: TextCellStyle) -> Int {
        //Font what is Font in swiftUI
        let fontSize: CGFloat = 14 // Assuming you have a font size in your style
        let averageCharacterWidth: CGFloat = fontSize * 0.5 // This is a rough estimate
        let containerWidth: CGFloat = maxWidth // Use the calculated maxWidth for the text container
        let charactersPerLine = max(1, containerWidth / averageCharacterWidth)
        let lineCount = Int(ceil(CGFloat(text.count) / charactersPerLine))
        return lineCount
    }
    
    @available(iOS 15, *)
    private var formattedTagString : AttributedString {
        var attentionName : String = ""
        if let attentions = attentions {
            for name in attentions {
                attentionName += "@\(name) "
            }
        }
        
        var result = AttributedString(attentionName)
        result.foregroundColor = .blue

        return result +  AttributedString(text)
    }
    
    @available(iOS 15, *)
    private var defaultAttentionText: some View {
        
        VStack(alignment: .leading) {
            Text(formattedTagString)
                .fontWeight(cellStyle.textStyle.fontWeight)
                .modifier(EmojiModifier(text: text, defaultFont: cellStyle.textStyle.font))
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(cellStyle.textStyle.textColor)
                .padding(cellStyle.textPadding)
            if self.computeLineCount(for: text, with: cellStyle) > 20 {
                showMore
            }

            if priortiy == .high || priortiy == .medium {
                PriorityMessageViewStyle(priorityLevel: priortiy)
                    .padding(.bottom,10)
                    .padding(.leading,10)
                    .frame(alignment: .leading)
                    .shadow (
                        color: cellStyle.cellShadowColor,
                        radius: cellStyle.cellShadowRadius
                    )
            }
        }
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
        if let attentions = attentions, attentions.count > 0 {
            if #available(iOS 15, *) {
                defaultAttentionText
            } else {
                defaultText
            }
        }else{
            defaultText
        }
    }
    
}
