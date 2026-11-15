//
//  ContactMessageView.swift
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

struct ContactMessageView<Message: ChatMessage>: View {

    let contact: ContactItem
    let message: Message
    let size: CGSize
    let footerSection: (ContactItem, Message) -> [ContactCellButton]
    
    // Cache buttons to avoid recomputation
    private let cachedButtons: [ContactCellButton]

    @Environment(\.chatStyle) var style
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    init(contact: ContactItem, message: Message, size: CGSize, footerSection: @escaping (ContactItem, Message) -> [ContactCellButton]) {
        self.contact = contact
        self.message = message
        self.size = size
        self.footerSection = footerSection
        self.cachedButtons = footerSection(contact, message)
    }

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
                .clipShape(.rect(cornerRadius: imageStyle.cornerRadius))
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

    @ViewBuilder
    private var buttonActionFooter: some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(spacing: 0) {
                ForEach(cachedButtons.indices, id: \.self) { index in
                    if index > 0 { Divider() }
                    contactActionButton(at: index)
                }
            }
        } else {
            HStack(spacing: 0) {
                ForEach(cachedButtons.indices, id: \.self) { index in
                    if index > 0 { Divider() }
                    contactActionButton(at: index)
                }
            }
        }
    }

    private func contactActionButton(at index: Int) -> some View {
        Button(cachedButtons[index].title, action: cachedButtons[index].action)
            .buttonStyle(.borderless)
            .frame(maxWidth: .infinity, minHeight: 44)
            .fixedSize(horizontal: false, vertical: true)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                contactImage
                fullNameLabel
                Spacer()
                Image(systemName: "chevron.right")
                    .shadow(color: .secondary, radius: 1)
                    .accessibilityHidden(true)

            }.padding()

            Spacer()
            Divider()
            buttonActionFooter
        }
        .frame(width: cardWidth)
        .background(
            cellStyle.cellBackgroundColor
                .clipShape(.rect(cornerRadius: cellStyle.cellCornerRadius))
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
            .foregroundStyle(cellStyle.fullNameLabelStyle.textColor)
            .fixedSize(horizontal: false, vertical: true)
            .layoutPriority(1)
    }
}
