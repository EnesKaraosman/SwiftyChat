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

public struct ContactCell<Message: ChatMessage>: View {
    
    public let contact: ContactItem
    public let message: Message
    public let size: CGSize
    public let footerSection: (ContactItem, Message) -> [ContactCellButton]
    
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
    
    // MARK: - Image
    @ViewBuilder private var contactImage: some View {
        if let contactImage = contact.image {
            Image(uiImage: contactImage)
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
        return self.footerSection(contact, message)
    }
    
    private var buttonActionFooter: some View {
        HStack {
            
            ForEach(self.buttons.indices) { idx in
                Button(self.buttons[idx].title) {}
                    .buttonStyle(BorderlessButtonStyle())
                    .simultaneousGesture(
                        TapGesture().onEnded(self.buttons[idx].action)
                    )
                    .frame(maxWidth: .infinity)
                
                if idx != self.buttons.count - 1 {
                    Divider()
                }
            }
            
        }
        .frame(height: 40)
    }
    
    // MARK: - Body
    public var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                self.contactImage
                self.fullNameLabel
                Spacer()
                Image(systemName: "chevron.right")
                    .shadow(color: .secondary, radius: 1)
                
            }.padding()
            
            Spacer()
            Divider()
            self.buttonActionFooter
            
        }
        .frame(width: self.cardWidth)
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
    
    // MARK: - Fullname Label
    private var fullNameLabel: some View {
        Text(contact.displayName)
            .font(cellStyle.fullNameLabelStyle.font)
            .fontWeight(cellStyle.fullNameLabelStyle.fontWeight)
            .foregroundColor(cellStyle.fullNameLabelStyle.textColor)
    }
    
}
