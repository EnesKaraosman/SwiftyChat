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
    public let action: (ContactItem) -> Void
    
    init(title: String, action: @escaping (ContactItem) -> Void) {
        self.title = title
        self.action = action
    }
}

public struct DefaultContactCell: View {
    
    public let contact: ContactItem
    public let message: ChatMessage
    public let proxy: GeometryProxy
    public let footerButtons: [ContactCellButton]
    
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var cardWidth: CGFloat {
        proxy.size.width * (UIDevice.isLandscape ? 0.4 : 0.8)
    }
    
    private var contactImage: some View {
        let profile = contact.image ?? UIImage(systemName: "person.crop.circle")!
        return Image(uiImage: profile)
            .resizable()
            .scaledToFit()
            .frame(width: 50)
            .shadow(color: .secondary, radius: 1)
    }
    
    private var buttonActionFooter: some View {
        HStack {
            
            ForEach(footerButtons.indices) { idx in
                Button(self.footerButtons[idx].title) {}
                    .simultaneousGesture(TapGesture().onEnded {
                        self.footerButtons[idx].action(self.contact)
                    }).frame(maxWidth: .infinity)
                if idx != self.footerButtons.count {
                    Divider()
                }
            }
            
        }
        .frame(height: 40)
    }
    
    public var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                
                contactImage
                
                Text(contact.displayName)
                Spacer()
                
                Image(systemName: "chevron.right")
                    .shadow(color: .secondary, radius: 1)
                
            }.padding()
            
            Spacer()
            Divider()
            
            buttonActionFooter
            
        }
        .frame(width: self.cardWidth, height: 130)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    message.isSender ? style.incomingBorderColor : style.outgoingBorderColor,
                    lineWidth: 2
                )
                .shadow(
                    color: message.isSender ? style.incomingShadowColor : style.outgoingShadowColor,
                    radius: 2
                )
        )
        
    }
    
}
