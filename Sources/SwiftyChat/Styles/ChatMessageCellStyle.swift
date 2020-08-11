//
//  MessageCellStyle.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public class ChatMessageCellStyle: ObservableObject {
    
    var incomingBorderColor: Color
    var outgoingBorderColor: Color
    
    var incomingTextColor: Color
    var outgoingTextColor: Color
    
    var incomingBackgroundColor: Color
    var outgoingBackgroundColor: Color
    
    var incomingCornerRadius: CGFloat
    var outgoingCornerRadius: CGFloat
    
    var incomingBorderWidth: CGFloat
    var outgoingBorderWidth: CGFloat
    
    var incomingShadowColor: Color
    var outgoingShadowColor: Color
    
    var incomingShadowRadius: CGFloat
    var outgoingShadowRadius: CGFloat
    
    var incomingTextPadding: CGFloat
    var outgoingTextPadding: CGFloat
    
    /// Cell container inset for incoming messages
    let incomingCellEdgeInsets: EdgeInsets?
    
    /// Cell container inset for outgoing messages
    let outgoingCellEdgeInsets: EdgeInsets?
    
    /// Contact Cell Style
    let contactCellStyle: ContactCellStyle
    
    /// Image Cell Style
    let imageCellStyle: ImageCellStyle
    
    /// Quick Reply Cell Style
    let quickReplyCellStyle: QuickReplyCellStyle
    
    /// Carousel Cell Style
    let carouselCellStyle: CarouselCellStyle
    
    /// Location Cell Style
    let locationCellStyle: LocationCellStyle
    
    /// Incoming Avatar Style
    let incomingAvatarStyle: AvatarStyle
    
    /// Outgoing Avatar Style
    let outgoingAvatarStyle: AvatarStyle
    
    public init(
        incomingBorderColor: Color = Color(#colorLiteral(red: 0.4539314508, green: 0.6435066462, blue: 0.3390129805, alpha: 1)),
        outgoingBorderColor: Color = Color(#colorLiteral(red: 0.2179558277, green: 0.202344358, blue: 0.2716280818, alpha: 1)),
        incomingTextColor: Color = .white,
        outgoingTextColor: Color = .white,
        incomingBackgroundColor: Color = Color(#colorLiteral(red: 0.4539314508, green: 0.6435066462, blue: 0.3390129805, alpha: 1)),
        outgoingBackgroundColor: Color = Color(#colorLiteral(red: 0.2179558277, green: 0.202344358, blue: 0.2716280818, alpha: 1)),
        incomingCornerRadius: CGFloat = 8,
        outgoingCornerRadius: CGFloat = 8,
        incomingBorderWidth: CGFloat = 2,
        outgoingBorderWidth: CGFloat = 2,
        incomingShadowColor: Color = .secondary,
        outgoingShadowColor: Color = .secondary,
        incomingShadowRadius: CGFloat = 3,
        outgoingShadowRadius: CGFloat = 3,
        incomingTextPadding: CGFloat = 8,
        outgoingTextPadding: CGFloat = 8,
        incomingCellEdgeInsets: EdgeInsets? = nil,
        outgoingCellEdgeInsets: EdgeInsets? = nil,
        contactCellStyle: ContactCellStyle = ContactCellStyle(),
        imageCellStyle: ImageCellStyle = ImageCellStyle(),
        quickReplyCellStyle: QuickReplyCellStyle = QuickReplyCellStyle(),
        carouselCellStyle: CarouselCellStyle = CarouselCellStyle(),
        locationCellStyle: LocationCellStyle = LocationCellStyle(),
        incomingAvatarStyle: AvatarStyle = AvatarStyle(),
        outgoingAvatarStyle: AvatarStyle = AvatarStyle(
            imageStyle: CommonImageStyle(imageSize: .zero)
        )
    ) {
        self.incomingBorderColor = incomingBorderColor
        self.outgoingBorderColor = outgoingBorderColor
        self.incomingTextColor = incomingTextColor
        self.outgoingTextColor = outgoingTextColor
        self.incomingBackgroundColor = incomingBackgroundColor
        self.outgoingBackgroundColor = outgoingBackgroundColor
        self.incomingCornerRadius = incomingCornerRadius
        self.outgoingCornerRadius = outgoingCornerRadius
        self.incomingBorderWidth = incomingBorderWidth
        self.outgoingBorderWidth = outgoingBorderWidth
        self.incomingShadowColor = incomingShadowColor
        self.outgoingShadowColor = outgoingShadowColor
        self.incomingShadowRadius = incomingShadowRadius
        self.outgoingShadowRadius = outgoingShadowRadius
        self.incomingTextPadding = incomingTextPadding
        self.outgoingTextPadding = outgoingTextPadding
        self.incomingCellEdgeInsets = incomingCellEdgeInsets
        self.outgoingCellEdgeInsets = outgoingCellEdgeInsets
        self.contactCellStyle = contactCellStyle
        self.imageCellStyle = imageCellStyle
        self.quickReplyCellStyle = quickReplyCellStyle
        self.carouselCellStyle = carouselCellStyle
        self.locationCellStyle = locationCellStyle
        self.incomingAvatarStyle = incomingAvatarStyle
        self.outgoingAvatarStyle = outgoingAvatarStyle
    }
    
}
