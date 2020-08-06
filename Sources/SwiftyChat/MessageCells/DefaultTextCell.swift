//
//  TextCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public struct DefaultTextCell: View {
    
    public let text: String
    public let message: ChatMessage
    public let size: CGSize
    public let callback: () -> TextTappedCallback

    @EnvironmentObject var style: ChatMessageCellStyle

    private let enabledDetectors: [DetectorType] = [.address, .date, .phoneNumber, .url, .transitInformation]
    private var maxWidth: CGFloat {
        size.width * (UIDevice.isLandscape ? 0.75 : 0.6)
    }
    
    private var action: TextTappedCallback {
        return callback()
    }
    
    // MARK: - Default Text
    private var defaultText: some View {
        Text(text)
        .foregroundColor(message.isSender ? style.incomingTextColor : style.outgoingTextColor)
        .padding(message.isSender ? style.incomingTextPadding : style.outgoingTextPadding)
        .lineLimit(nil)
        .background(message.isSender ? style.incomingBackgroundColor : style.outgoingBackgroundColor)
        .clipShape(
            RoundedRectangle(
                cornerRadius: message.isSender ? style.incomingCornerRadius : style.outgoingCornerRadius
            )
        )
        .shadow(
            color: message.isSender ? style.incomingShadowColor : style.outgoingShadowColor,
            radius: message.isSender ? style.incomingShadowRadius : style.outgoingShadowRadius
        )
        .modifier(EmojiModifier(text: text))
    }
    
    private var attributedText: some View {
        AttributedText(text: text, width: maxWidth) {
            
            $0.enabledDetectors = self.enabledDetectors
            $0.didSelectAddress = self.action.didSelectAddress
            $0.didSelectDate = self.action.didSelectDate
            $0.didSelectPhoneNumber = self.action.didSelectPhoneNumber
            $0.didSelectURL = self.action.didSelectURL
            $0.didSelectTransitInformation = self.action.didSelectTransitInformation
//            $0.didSelectMention = self.action.didSelectMention
//            $0.didSelectHashtag = self.action.didSelectHashtag
            
            $0.font = .systemFont(ofSize: 17)
            $0.textColor = .white // TODO: Configure color
            $0.textAlignment = self.message.isSender ? .right : .left
        }
        .padding(message.isSender ? style.incomingTextPadding : style.outgoingTextPadding)
        .background(message.isSender ? style.incomingBackgroundColor : style.outgoingBackgroundColor)
        .clipShape(
            RoundedRectangle(
                cornerRadius: message.isSender ? style.incomingCornerRadius : style.outgoingCornerRadius
            )
        )
        .shadow(
            color: message.isSender ? style.incomingShadowColor : style.outgoingShadowColor,
            radius: message.isSender ? style.incomingShadowRadius : style.outgoingShadowRadius
        )
    }
    
    public var body: some View {
        Group {
            if AttributeDetective(text: text, enabledDetectors: enabledDetectors).doesContain() {
                self.attributedText
            } else {
                self.defaultText
            }
        }
    }
    
}
