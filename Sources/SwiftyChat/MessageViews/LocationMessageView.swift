//
//  LocationMessageView.swift
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import MapKit
import SwiftUI

struct LocationMessageView<Message: ChatMessage>: View {

    let location: LocationItem
    let message: Message
    let size: CGSize
    @Environment(\.chatStyle) var style

    private var mapWidth: CGFloat {
        cellStyle.cellWidth(size)
    }

    private var cellStyle: LocationCellStyle {
        style.locationCellStyle
    }

    var body: some View {
        mapView
            .frame(
                width: mapWidth,
                height: mapWidth * cellStyle.cellAspectRatio
            )
            .clipShape(.rect(cornerRadius: cellStyle.cellCornerRadius))
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

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }

    private var mapCameraPosition: MapCameraPosition {
        .region(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        ))
    }

    private var mapView: some View {
        Map(initialPosition: mapCameraPosition, interactionModes: .zoom) {
            Marker("", coordinate: coordinate)
        }
    }
}
