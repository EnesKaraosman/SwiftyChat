//
//  DefaultContactCell.swift
//
//
//  Created by Enes Karaosman on 25.05.2020.
//

import SwiftUI

public struct ContactCellButton: Identifiable {
    public let id = UUID()
    public let title: String
    public let action: () -> Void

    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
}

internal struct ContactCell<Message: ChatMessage>: View {

    let contact: ContactItem
    let message: Message
    let size: CGSize
    let footerSection: (ContactItem, Message) -> [ContactCellButton]

    @EnvironmentObject var style: ChatMessageCellStyle

    private var cellStyle: ContactCellStyle {
        style.contactCellStyle
    }

    private var imageStyle: CommonImageStyle {
        cellStyle.imageStyle
    }

    private var cardWidth: CGFloat {
        cellStyle.cellWidth(size)
    }

    @ViewBuilder
    private var contactImage: some View {
        if let contactImage = contact.image {
            Image(image: contactImage)
                .resizable()
                .frame(
                    width: imageStyle.imageSize.width,
                    height: imageStyle.imageSize.height
                )
                .scaledToFit()
                .cornerRadius(imageStyle.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: imageStyle.cornerRadius)
                        .stroke(
                            imageStyle.borderColor,
                            lineWidth: imageStyle.borderWidth
                        )
                        .shadow(
                            color: imageStyle.shadowColor,
                            radius: imageStyle.shadowRadius
                        )
                )
        }
    }

    private var buttons: [ContactCellButton] {
        return footerSection(contact, message)
    }

    private var buttonActionFooter: some View {
        HStack {
            ForEach(0..<buttons.count, id: \.self) { idx in
                Button(buttons[idx].title) {}
                    .buttonStyle(BorderlessButtonStyle())
                    .simultaneousGesture(
                        TapGesture().onEnded(buttons[idx].action)
                    )
                    .frame(maxWidth: .infinity)

                if idx != buttons.count - 1 {
                    Divider()
                }
            }
        }
        .frame(height: 40)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                contactImage
                fullNameLabel
                Spacer()
                Image(systemName: "chevron.right")
                    .shadow(color: .secondary, radius: 1)

            }.padding()

            Spacer()
            Divider()
            buttonActionFooter
        }
        .frame(width: cardWidth)
        .background(
            cellStyle.cellBackgroundColor
                .cornerRadius(cellStyle.cellCornerRadius)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
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

    private var fullNameLabel: some View {
        Text(contact.displayName)
            .font(cellStyle.fullNameLabelStyle.font)
            .fontWeight(cellStyle.fullNameLabelStyle.fontWeight)
            .foregroundColor(cellStyle.fullNameLabelStyle.textColor)
    }
}
