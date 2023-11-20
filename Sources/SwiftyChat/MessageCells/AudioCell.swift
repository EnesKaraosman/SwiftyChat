//
//  AudioCell.swift
//  
//
//  Created by AL Reyes on 6/19/23.
//

import SwiftUI


internal struct AudioCell<Message: ChatMessage>: View {
    @EnvironmentObject var style: ChatMessageCellStyle
    public let message: Message
    public let audioURL : URL
    public let size: CGSize
    public let priortiy: MessagePriorityLevel

    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                AudioPlayerView(audioURL: audioURL)

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
            
        }
        //.frame(width: width)
        .background(cellStyle.cellBackgroundColor)
        .clipShape(RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners))
        .overlay(
            
            RoundedCornerShape(radius: cellStyle.cellCornerRadius, corners: cellStyle.cellRoundedCorners)
            .stroke(
                cellStyle.cellBorderColor,
                lineWidth: cellStyle.cellBorderWidth  * 0.8
            )
            .shadow(
                color: cellStyle.cellShadowColor,
                radius: cellStyle.cellShadowRadius
            )
        )

    }
}
