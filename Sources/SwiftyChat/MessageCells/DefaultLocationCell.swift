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
    
    public let location: LocationItem
    public let message: ChatMessage
    public let proxy: GeometryProxy
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var mapWidth: CGFloat {
        cellStyle.cellWidth(proxy)
    }
    
    private var cellStyle: LocationCellStyle {
        style.locationCellStyle
    }
    
    public var body: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        .frame(
            width: mapWidth,
            height: mapWidth * cellStyle.cellAspectRatio
        )
        .cornerRadius(cellStyle.cellCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cellStyle.cellCornerRadius)
                .stroke(
                    cellStyle.cellBorderColor,
                    lineWidth: cellStyle.cellBorderWidth
                )
        )
        .shadow(
            color: cellStyle.cellShadowColor,
            radius: cellStyle.cellShadowRadius
        )
    }
    
}
