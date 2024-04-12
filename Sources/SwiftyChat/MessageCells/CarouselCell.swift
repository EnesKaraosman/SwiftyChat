//
//  DefaultCarouselCell.swift
//
//
//  Created by Enes Karaosman on 23.07.2020.
//

import SwiftUI
import Kingfisher

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

internal struct CarouselCell<Message: ChatMessage>: View {

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
    }

}

internal struct CarouselItemView: View {

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

    var body: some View {
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
                    Button(action: { callback(button) }) {
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
