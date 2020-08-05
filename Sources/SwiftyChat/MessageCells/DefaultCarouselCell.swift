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
    public let url: URL?
    public let title: String
    
    public init(title: String, url: URL?) {
        self.title = title
        self.url = url
    }
}

public struct CarouselItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let picture: URL?
    public let subtitle: String
    public let buttons: [CarouselItemButton]
    
    public init(title: String, subtitle: String, imageURL: URL?, buttons: [CarouselItemButton]) {
        self.title = title
        self.subtitle = subtitle
        self.picture = imageURL
        self.buttons = buttons
    }
}

public struct DefaultCarouselCell: View {
    
    public let carouselItems: [CarouselItem]
    public let proxy: GeometryProxy
    public let message: ChatMessage
    public let onCarouselItemAction: (URL?, ChatMessage) -> Void
    
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(carouselItems) { item in
                    CarouselItemView(
                        item: item,
                        proxy: self.proxy,
                        isSender: self.message.isSender
                    ) { url in
                        self.onCarouselItemAction(url, self.message)
                    }
                }
            }
        }
    }
}

public struct CarouselItemView: View {
    
    public let item: CarouselItem
    public let proxy: GeometryProxy
    public let isSender: Bool
    public let callback: (URL?) -> Void
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var cellStyle: CarouselCellStyle {
        style.carouselCellStyle
    }
    
    private var itemWidth: CGFloat {
        cellStyle.cellWidth(proxy)
    }
    
    public var body: some View {
        VStack {
            
            KFImage(item.picture)
                .resizable()
                .scaledToFit()
            
            Group {
                Text(item.title)
                    .fontWeight(cellStyle.titleFontWeight)
                    .font(cellStyle.titleFont)
                    .foregroundColor(cellStyle.titleColor)
                    .multilineTextAlignment(.center)
                
                Text(item.subtitle)
                    .fontWeight(cellStyle.subtitleFontWeight)
                    .font(cellStyle.subtitleFont)
                    .foregroundColor(cellStyle.subtitleColor)
                    .multilineTextAlignment(.center)
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(8)
            
            HStack {
                ForEach(item.buttons) { (button) in
                    Button(action: { self.callback(button.url) }) {
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
