//
//  SwiftUIView.swift
//  
//
//  Created by AL Reyes on 2/22/23.
//

import SwiftUI

internal struct ReplyCell<Message: ChatMessage>: View {
    @EnvironmentObject var style: ChatMessageCellStyle
    public let message: Message
    public let replies : [any ReplyItem]
    public let reply : any ReplyItem
    public let size: CGSize
    
    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }
    
    var body: some View {
        
        
    LazyVStack(alignment: message.isSender ? .trailing : .leading,spacing: 0) {
        ZStack {
            Group {
                VStack(alignment: message.isSender ? .trailing : .leading,spacing: 0) {
                    ForEach(replies, id: \.id) { item in
                        ReplyItemCell(reply: item, message: message, size: size)
                            .padding(.bottom)
                            .overlay (
                                VStack {
                                    Spacer()
                                    Divider()
                                        .background(cellStyle.textStyle.textColor)
                                }
                            )
                    }
                    
                    switch reply.fileType {
                    case .video:
                        ImageCell(
                            message: message,
                            imageLoadingType: ImageLoadingKind.remote(URL(string: reply.thumbnailURL!)!),
                            size: size
                        )
                    case .image:
                        ImageCell(
                            message: message,
                            imageLoadingType: ImageLoadingKind.remote(URL(string: reply.thumbnailURL!)!),
                            size: size
                        )
                        .padding(.top,10)
                    case.text :
                        EmptyView()
                    }
                    if let text = reply.text, text.count > 0{
                        Text(text)
                            .fontWeight(cellStyle.textStyle.fontWeight)
                            .modifier(EmojiModifier(text: reply.text!, defaultFont: cellStyle.textStyle.font))
                            .lineLimit(nil)
                            .foregroundColor(cellStyle.textStyle.textColor)
                            .padding(.top,10)

                    }

                }

            }
        }
           
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
    }
}

