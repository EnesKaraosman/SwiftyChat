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
    
    private var itemWidth: CGFloat {
        proxy.size.width * (UIDevice.isLandscape ? 0.6 : 0.7)
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(carouselItems) { item in
                    CarouselItemView(item: item, itemWidth: itemWidth, isSender: message.isSender) { url in
                        onCarouselItemAction(url, message)
                    }
                }
            }
        }
    }
}

public struct CarouselItemView: View {
    
    public let item: CarouselItem
    public let itemWidth: CGFloat
    public let isSender: Bool
    public let callback: (URL?) -> Void
    @EnvironmentObject var style: ChatMessageCellStyle
    
    public var body: some View {
        VStack {
            
            KFImage(item.picture)
                .resizable()
                .frame(width: itemWidth, height: itemWidth)
                .scaledToFill()
            
            Group {
                Text(item.title)
                    .fontWeight(.semibold)
                    .font(.title)
                    .lineLimit(nil)
                
                Text(item.subtitle)
                    .multilineTextAlignment(.center)
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(8)
            
            HStack {
                ForEach(item.buttons) { (button) in
                    Button(action: { callback(button.url) }) {
                        Text(button.title)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(CarouselItemButtonStyle())
                }
            }
            
        }
        .background(Color(#colorLiteral(red: 0.9617928863, green: 0.9619538188, blue: 0.9617717862, alpha: 1)))
        .frame(width: itemWidth)
        .cornerRadius(isSender ? style.incomingCornerRadius : style.outgoingCornerRadius)
//        .overlay(
//            RoundedRectangle(cornerRadius: isSender ? style.incomingCornerRadius : style.outgoingCornerRadius)
//                .stroke(
//                    isSender ? style.incomingBorderColor : style.outgoingBorderColor,
//                    lineWidth: isSender ? style.incomingBorderWidth : style.outgoingBorderWidth
//                )
//        )
//        .shadow(
//            color: isSender ? style.incomingShadowColor : style.outgoingShadowColor,
//            radius: isSender ? style.incomingShadowRadius : style.outgoingShadowRadius
//        )
        
    }
    
}
