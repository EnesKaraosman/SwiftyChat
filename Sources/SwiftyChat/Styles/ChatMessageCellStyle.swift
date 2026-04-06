//
//  MessageCellStyle.swift
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public struct ChatMessageCellStyle {

    /// Incoming Text Style
    public let incomingTextStyle: TextCellStyle

    /// Outgoing Text Style
    public let outgoingTextStyle: TextCellStyle

    /// Cell container inset for incoming messages
    public let incomingCellEdgeInsets: EdgeInsets

    /// Cell container inset for outgoing messages
    public let outgoingCellEdgeInsets: EdgeInsets

    /// Contact Cell Style
    public let contactCellStyle: ContactCellStyle

    /// Image Cell Style
    public let imageCellStyle: ImageCellStyle

    /// Image and Text Cell Style
    public let imageTextCellStyle: ImageTextCellStyle

    /// Quick Reply Cell Style
    public let quickReplyCellStyle: QuickReplyCellStyle

    /// Carousel Cell Style
    public let carouselCellStyle: CarouselCellStyle

    /// Location Cell Style
    public let locationCellStyle: LocationCellStyle

    /// Video Placeholder Cell Style
    public let videoPlaceholderCellStyle: VideoPlaceholderCellStyle

    /// Link Preview Cell Style
    public let linkPreviewCellStyle: LinkPreviewCellStyle

    /// Incoming Avatar Style
    public let incomingAvatarStyle: AvatarStyle

    /// Outgoing Avatar Style
    public let outgoingAvatarStyle: AvatarStyle

    public init(
        incomingTextStyle: TextCellStyle = TextCellStyle(
            textStyle: CommonTextStyle(
                textColor: .white,
                font: Font.custom("Futura", size: 17)
            ),
            cellBackgroundColor: Color.pink.opacity(0.8)
        ),
        outgoingTextStyle: TextCellStyle = TextCellStyle(
            textStyle: CommonTextStyle(
                textColor: .white,
                font: Font.custom("Tahoma", size: 17),
                fontWeight: .bold
            )
        ),
        incomingCellEdgeInsets: EdgeInsets = EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4),
        outgoingCellEdgeInsets: EdgeInsets = EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4),
        contactCellStyle: ContactCellStyle = ContactCellStyle(),
        imageCellStyle: ImageCellStyle = ImageCellStyle(),
        imageTextCellStyle: ImageTextCellStyle = ImageTextCellStyle(),
        quickReplyCellStyle: QuickReplyCellStyle = QuickReplyCellStyle(),
        carouselCellStyle: CarouselCellStyle = CarouselCellStyle(),
        locationCellStyle: LocationCellStyle = LocationCellStyle(),
        videoPlaceholderCellStyle: VideoPlaceholderCellStyle = VideoPlaceholderCellStyle(),
        linkPreviewCellStyle: LinkPreviewCellStyle = LinkPreviewCellStyle(),
        incomingAvatarStyle: AvatarStyle = AvatarStyle(),
        outgoingAvatarStyle: AvatarStyle = AvatarStyle(
            imageStyle: CommonImageStyle(imageSize: .zero)
        )
    ) {
        self.incomingTextStyle = incomingTextStyle
        self.outgoingTextStyle = outgoingTextStyle
        self.incomingCellEdgeInsets = incomingCellEdgeInsets
        self.outgoingCellEdgeInsets = outgoingCellEdgeInsets
        self.contactCellStyle = contactCellStyle
        self.imageCellStyle = imageCellStyle
        self.imageTextCellStyle = imageTextCellStyle
        self.quickReplyCellStyle = quickReplyCellStyle
        self.carouselCellStyle = carouselCellStyle
        self.locationCellStyle = locationCellStyle
        self.videoPlaceholderCellStyle = videoPlaceholderCellStyle
        self.linkPreviewCellStyle = linkPreviewCellStyle
        self.incomingAvatarStyle = incomingAvatarStyle
        self.outgoingAvatarStyle = outgoingAvatarStyle
    }
}

// MARK: - Environment Key
extension EnvironmentValues {
    @Entry public var chatStyle: ChatMessageCellStyle = ChatMessageCellStyle()
}
