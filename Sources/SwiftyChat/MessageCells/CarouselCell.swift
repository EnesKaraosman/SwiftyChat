//
//  DefaultCarouselCell.swift
//  
//
//  Created by Enes Karaosman on 23.07.2020.
//

import SwiftUI
import KingfisherSwiftUI

public struct CarouselItemButton: Identifiable {
    public let id = UUID()
    public let title: String
    public let url: URL?
    public let payload: String?
    
    public init(title: String, url: URL? = nil, payload: String? = nil) {
        self.title = title
        self.url = url
        self.payload = payload
    }
}

extension CarouselItem {
    var id: String {
        (imageURL?.absoluteString ?? "").appending(subtitle)
    }
}

public struct CarouselCell: View {
    
    public let carouselItems: [CarouselItem]
    public let size: CGSize
    public let message: ChatMessage
    public let onCarouselItemAction: (CarouselItemButton, ChatMessage) -> Void
    
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(carouselItems, id: \.id) { item in
                    CarouselItemView(
                        item: item,
                        size: self.size,
                        isSender: self.message.isSender
                    ) { button in
                        self.onCarouselItemAction(button, self.message)
                    }
                }
            }
        }
    }
}

public struct CarouselItemView: View {
    
    public let item: CarouselItem
    public let size: CGSize
    public let isSender: Bool
    public let callback: (CarouselItemButton) -> Void
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var cellStyle: CarouselCellStyle {
        style.carouselCellStyle
    }
    
    private var itemWidth: CGFloat {
        cellStyle.cellWidth(size)
    }
    
    public var body: some View {
        VStack {
            
            KFImage(item.imageURL)
                .resizable()
                .scaledToFit()
            
            Group {
                Text(item.title)
                    .fontWeight(cellStyle.titleLabelStyle.fontWeight)
                    .font(cellStyle.titleLabelStyle.font)
                    .foregroundColor(cellStyle.titleLabelStyle.textColor)
                    .multilineTextAlignment(.center)
                
                Text(item.subtitle)
                    .fontWeight(cellStyle.subtitleLabelStyle.fontWeight)
                    .font(cellStyle.subtitleLabelStyle.font)
                    .foregroundColor(cellStyle.subtitleLabelStyle.textColor)
                    .multilineTextAlignment(.center)
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(8)
            
            HStack {
                ForEach(item.buttons) { (button) in
                    Button(action: { self.callback(button) }) {
                        Text(button.title)
                            .fontWeight(self.cellStyle.buttonTitleFontWeight)
                            .font(self.cellStyle.buttonFont)
                            .foregroundColor(self.cellStyle.buttonTitleColor)
                    }
                    .buttonStyle(
                        CarouselItemButtonStyle(
                            backgroundColor: self.cellStyle.buttonBackgroundColor
                        )
                    )
                }
            }
            
        }
        .background(self.cellStyle.cellBackgroundColor)
        .frame(width: itemWidth)
        .cornerRadius(self.cellStyle.cellCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: self.cellStyle.cellCornerRadius)
                .stroke(
                    self.cellStyle.cellBorderColor,
                    lineWidth: self.cellStyle.cellBorderWidth
                )
                .shadow(
                    color: self.cellStyle.cellShadowColor,
                    radius: self.cellStyle.cellShadowRadius
                )
        )
        
    }
    
}
