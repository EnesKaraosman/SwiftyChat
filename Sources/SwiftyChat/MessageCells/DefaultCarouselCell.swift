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
                    CarouselItemView(item: item, proxy: proxy, isSender: message.isSender) { url in
                        onCarouselItemAction(url, message)
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
                    Button(action: { callback(button.url) }) {
                        Text(button.title)
                            .fontWeight(cellStyle.buttonTitleFontWeight)
                            .font(cellStyle.buttonFont)
                            .foregroundColor(cellStyle.buttonTitleColor)
                    }
                    .buttonStyle(
                        CarouselItemButtonStyle(
                            backgroundColor: cellStyle.buttonBackgroundColor
                        )
                    )
                }
            }
            
        }
        .background(cellStyle.cellBackgroundColor)
        .frame(width: itemWidth)
        .cornerRadius(cellStyle.cellCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cellStyle.cellCornerRadius)
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
