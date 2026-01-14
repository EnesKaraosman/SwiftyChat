//
//  CarouselMessageView.swift
//
//
//  Created by Enes Karaosman on 23.07.2020.
//

import Kingfisher
import SwiftUI

public struct CarouselItemButton: Identifiable, Hashable {
    public var id: String {
        var hasher = Hasher()
        hasher.combine(title)
        hasher.combine(url?.absoluteString)
        hasher.combine(payload)
        return "\(hasher.finalize())"
    }
    public let title: String
    public let url: URL?
    public let payload: String?

    public init(title: String, url: URL? = nil, payload: String? = nil) {
        self.title = title
        self.url = url
        self.payload = payload
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(url?.absoluteString)
        hasher.combine(payload)
    }
    
    public static func == (lhs: CarouselItemButton, rhs: CarouselItemButton) -> Bool {
        lhs.title == rhs.title && lhs.url == rhs.url && lhs.payload == rhs.payload
    }
}

private extension CarouselItem {
    var id: String {
        (imageURL?.absoluteString ?? "").appending(subtitle)
    }
}

struct CarouselMessageView<Message: ChatMessage>: View {

    let carouselItems: [CarouselItem]
    let size: CGSize
    let message: Message
    let onCarouselItemAction: (CarouselItemButton, Message) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(carouselItems, id: \.id) { item in
                    CarouselItemView(
                        item: item,
                        size: size,
                        isSender: message.isSender
                    ) { button in
                        onCarouselItemAction(button, message)
                    }
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

private struct CarouselItemView: View {

    let item: CarouselItem
    let size: CGSize
    let isSender: Bool
    let callback: (CarouselItemButton) -> Void
    @EnvironmentObject var style: ChatMessageCellStyle

    private var cellStyle: CarouselCellStyle {
        style.carouselCellStyle
    }

    private var itemWidth: CGFloat {
        cellStyle.cellWidth(size)
    }
    
    // Fixed image height based on item width (16:9 aspect ratio)
    private var imageHeight: CGFloat {
        itemWidth * 9 / 16
    }

    var body: some View {
        VStack {

            KFImage(item.imageURL)
                .resizable()
                .placeholder { _ in
                    Rectangle()
                        .fill(Color.secondary.opacity(0.2))
                        .frame(width: itemWidth, height: imageHeight)
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: itemWidth, height: imageHeight)
                .clipped()

            Group {
                Text(item.title)
                    .fontWeight(cellStyle.titleLabelStyle.fontWeight)
                    .font(cellStyle.titleLabelStyle.font)
                    .foregroundColor(cellStyle.titleLabelStyle.textColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text(item.subtitle)
                    .fontWeight(cellStyle.subtitleLabelStyle.fontWeight)
                    .font(cellStyle.subtitleLabelStyle.font)
                    .foregroundColor(cellStyle.subtitleLabelStyle.textColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(8)

            HStack {
                ForEach(item.buttons) { (button) in
                    Button(
                        action: {
                            callback(button)
                        },
                        label: {
                            Text(button.title)
                                .fontWeight(cellStyle.buttonTitleFontWeight)
                                .font(cellStyle.buttonFont)
                                .foregroundColor(cellStyle.buttonTitleColor)
                        }
                    )
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
