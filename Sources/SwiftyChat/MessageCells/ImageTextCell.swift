//
//  ImageTextCell.swift
//
//
//  Created by Karl Söderberg on 25.10.2021.
//
//

import SwiftUI

internal struct ImageTextCell<Message: ChatMessage>: View {
    
    public let message: Message
    public let attentions: [String]?
    public let imageLoadingType: ImageLoadingKind
    public let text: String
    public let size: CGSize
    public let priority: MessagePriorityLevel
    public let actionStatus: ActionItemStatus?
    public let didTappedViewTask : (Message) -> Void

    @EnvironmentObject var style: ChatMessageCellStyle
    
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
    
    private var imageWidth: CGFloat {
        cellStyle.cellWidth(size)
    }
    
    private var cellStyle: ImageTextCellStyle {
        style.imageTextCellStyle
    }
    
    @ViewBuilder private var imageView: some View {
        
        if case let ImageLoadingKind.local(uiImage) = imageLoadingType {
            let width = uiImage.size.width
            let height = uiImage.size.height
            let isLandscape = width > height
            ImageLoadingKindCell(
                imageLoadingType,
                width: imageWidth,
                height: isLandscape ? nil : height * (imageWidth / width)
            )
        } else {
            ImageLoadingKindCell(
                imageLoadingType,
                width: imageWidth
            )
        }
    }
    
    @ViewBuilder public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageView
            
            if #available(iOS 15, *) {
                Text(formattedTagString)
                    .fontWeight(cellStyle.textStyle.fontWeight)
                    .modifier(EmojiModifier(text: text, defaultFont: cellStyle.textStyle.font))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(cellStyle.textStyle.textColor)
                    .padding(cellStyle.textPadding)

            } else {
                Text(text)
                    .fontWeight(cellStyle.textStyle.fontWeight)
                    .modifier(EmojiModifier(text: text, defaultFont: cellStyle.textStyle.font))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(cellStyle.textStyle.textColor)
                    .padding(cellStyle.textPadding)
            }
            
            HStack(){

                if let status = actionStatus {
                    PriorityMessageViewStyle(priorityLevel: priority)
                        .padding(.bottom,10)
                        .padding(.trailing,10)
                        .padding(.leading,10)
                        .frame(alignment: .leading)
                        .shadow (
                            color: cellStyle.cellShadowColor,
                            radius: cellStyle.cellShadowRadius
                        )
                    Spacer()
                    TaskMessageViewSytle(status: status)
                        .padding(.bottom,10)
                        .padding(.trailing,10)
                        .padding(.leading,10)
                        .frame(alignment: .trailing)
                        .shadow (
                            color: cellStyle.cellShadowColor,
                            radius: cellStyle.cellShadowRadius
                        )
                        .onTapGesture(perform: {
                            self.didTappedViewTask(self.message)
                        })
                }
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
    
}

