//
//  LocationCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
import MapKit

internal struct LocationCell<Message: ChatMessage>: View {

    let location: LocationItem
    let message: Message
    let size: CGSize
    @EnvironmentObject var style: ChatMessageCellStyle

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

    @ViewBuilder private var mapView: some View {
        Map(
            coordinateRegion: .constant(
                MKCoordinateRegion(
                    center: .init(latitude: location.latitude, longitude: location.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                )
            ),
            interactionModes: MapInteractionModes.zoom,
            showsUserLocation: false,
            annotationItems: [
                LocationRow(
                    latitude: location.latitude,
                    longitude: location.longitude
                )
            ],
            annotationContent: { place in
                MapMarker(coordinate: place.coordinate)
            }
        )
    }

    private struct LocationRow: LocationItem, Identifiable {
        let id: String = UUID().uuidString
        var latitude: Double
        var longitude: Double
        var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}
