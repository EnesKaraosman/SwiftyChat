//
//  LocationCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
import struct MapKit.CLLocationCoordinate2D

public struct DefaultLocationCell: View {
    
    public let coordinate: CLLocationCoordinate2D
    public let message: ChatMessage
    public let proxy: GeometryProxy
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var mapWidth: CGFloat {
        proxy.size.width * (UIDevice.isLandscape ? 0.4 : 0.8)
    }
    
    public var body: some View {
        MapView(coordinate: coordinate)
        .frame(width: mapWidth, height: mapWidth)
        .cornerRadius(message.isSender ? style.incomingCornerRadius : style.outgoingCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: message.isSender ? style.incomingCornerRadius : style.outgoingCornerRadius)
                .stroke(
                    message.isSender ? style.incomingBorderColor : style.outgoingBorderColor,
                    lineWidth: message.isSender ? style.incomingBorderWidth : style.outgoingBorderWidth
                )
        )
        .shadow(
            color: message.isSender ? style.incomingShadowColor : style.outgoingShadowColor,
            radius: message.isSender ? style.incomingShadowRadius : style.outgoingShadowRadius
        )
    }
    
}
