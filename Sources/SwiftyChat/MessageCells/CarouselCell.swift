//
//  DefaultCarouselCell.swift
//  
//
//  Created by Enes Karaosman on 23.07.2020.
//

import SwiftUI
import SDWebImageSwiftUI

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
    
    @State var isAnimating: Bool = true
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(carouselItems, id: \.id) { item in
                    CarouselItemView(
                        item: item,
                        size: self.size,
                        isSender: self.message.isSender,
                        callback: { button in self.onCarouselItemAction(button, self.message) },
                        isAnimating: self.$isAnimating)
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
    @Binding var isAnimating: Bool
    
    private var cellStyle: CarouselCellStyle {
        style.carouselCellStyle
    }
    
    private var itemWidth: CGFloat {
        cellStyle.cellWidth(size)
    }
    private var itemHeight: CGFloat {
        cellStyle.cellHeight(size)
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            
            WebImage(url: item.imageURL, isAnimating: $isAnimating)
                .placeholder { Text("…") }
                .resizable()
                .clipped()
                .aspectRatio(contentMode: .fill)
                .frame(width: itemWidth, height: itemWidth * 0.776)
            
            Group {
                Text(item.title)
                    .fontWeight(cellStyle.titleLabelStyle.fontWeight)
                    .font(cellStyle.titleLabelStyle.font)
                    .foregroundColor(cellStyle.titleLabelStyle.textColor)
                    .multilineTextAlignment(.leading)
                    .padding([.top, .bottom], 12.5)
                
                Text(item.subtitle)
                    .fontWeight(cellStyle.subtitleLabelStyle.fontWeight)
                    .font(cellStyle.subtitleLabelStyle.font)
                    .foregroundColor(cellStyle.subtitleLabelStyle.textColor)
                    .multilineTextAlignment(.leading)
                    .padding([.bottom], 12.5)
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding([.leading, .trailing], 18)
            
            HStack {
                ForEach(item.buttons) { (button) in
                    Button(action: { /*self.callback(button)*/ }) {
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
            }.padding(0)
            
        }
        .background(self.cellStyle.cellBackgroundColor)
        .frame(width: itemWidth, height: itemHeight)
        .cornerRadius(self.cellStyle.cellCornerRadius)
        .clipped()
        .simultaneousGesture(
            TapGesture().onEnded { _ in
                if let button = self.item.buttons.first {
                    self.callback(button)
                }
            }
        )
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
