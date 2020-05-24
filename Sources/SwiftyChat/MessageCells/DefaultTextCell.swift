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
    @EnvironmentObject var style: ChatMessageCellStyle
    
    public var body: some View {
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
    
}
