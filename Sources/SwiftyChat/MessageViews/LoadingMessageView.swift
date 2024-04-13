//
//  LoadingMessageView.swift
//
//  Created by Karl Söderberg on 16.11.2021.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

struct LoadingMessageView<Message: ChatMessage>: View {

    let message: Message
    let size: CGSize

    @EnvironmentObject var style: ChatMessageCellStyle

    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }

    private var maxWidth: CGFloat {
        size.width * (Device.isLandscape ? 0.6 : 0.75)
    }

    var body: some View {
        LoadingThreeBalls(color: cellStyle.textStyle.textColor, size: .init(width: 40, height: 8))
            .frame(height: 42)
            .foregroundColor(cellStyle.textStyle.textColor)
            .padding(.horizontal, cellStyle.textPadding)
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
}

#if DEBUG
struct Loadingcell_Previews: PreviewProvider {
    static var previews: some View {
        LoadingMessageView(message: MockMessages.generateMessage(kind: .Text), size: .zero)
            .environmentObject(ChatMessageCellStyle.init())
    }
}
#endif
