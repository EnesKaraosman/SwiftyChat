//
//  MapView.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
import MapKit

internal struct MapView: UIViewRepresentable {

    public var coordinate: CLLocationCoordinate2D
    public var isScrollEnabled: Bool = false
    public var isZoomEnabled: Bool = false
    
    public func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, animated: true)
        mapView.isZoomEnabled = isZoomEnabled
        mapView.isScrollEnabled = isScrollEnabled
        centerMapOnLocation(coordinate, mapView: mapView)
        return mapView
    }

    public func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
    }
    
    // To play with zoom level, change regionRadius
    private func centerMapOnLocation(_ location: CLLocationCoordinate2D, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 5000
        let coordinateRegion = MKCoordinateRegion(
            center: location,
            latitudinalMeters: regionRadius * 2.0,
            longitudinalMeters: regionRadius * 2.0
        )
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}
