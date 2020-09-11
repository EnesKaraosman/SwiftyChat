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
    public let size: CGSize = .init(width: 320, height: 320)
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
                        isAnimating: self.$isAnimating
                    ).padding(.all, 11.5)
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
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    minWidth: itemWidth,
                    idealWidth: itemWidth,
                    maxWidth: itemWidth,
                    minHeight: itemWidth * 0.776,
                    idealHeight: itemWidth * 0.776,
                    maxHeight: itemWidth,
                    alignment: .center
                )
                .clipped()
            
            Group {
                if !item.title.isEmpty {
                    Text(item.title)
                        .fontWeight(cellStyle.titleLabelStyle.fontWeight)
                        .font(cellStyle.titleLabelStyle.font)
                        .foregroundColor(cellStyle.titleLabelStyle.textColor)
                        .multilineTextAlignment(.leading)
                        .padding([.top, .bottom], 12.5)
                }
                
                if !item.subtitle.isEmpty {
                    Text(item.subtitle)
                        .fontWeight(cellStyle.subtitleLabelStyle.fontWeight)
                        .font(cellStyle.subtitleLabelStyle.font)
                        .foregroundColor(cellStyle.subtitleLabelStyle.textColor)
                        .multilineTextAlignment(.leading)
                        .padding([.bottom], 12.5)
                }
                
            }
            .frame(minHeight: 46.3, idealHeight: 64)
            .padding([.leading, .trailing], 18)
            
            HStack {
                ForEach(item.buttons) { (button) in
                    Button(action: { /*self.callback(button)*/ }) {
                        Text(button.title)
                            .fontWeight(self.cellStyle.buttonTitleFontWeight)
                            .font(self.cellStyle.buttonFont)
                            .foregroundColor(self.cellStyle.buttonTitleColor)
                            .scaledToFit()
                    }
                    .buttonStyle(
                        CarouselItemButtonStyle(
                            backgroundColor: self.cellStyle.buttonBackgroundColor,
                            height: self.cellStyle.buttonHeight
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
