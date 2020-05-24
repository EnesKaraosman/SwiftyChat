//
//  MapView.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
import MapKit

public struct MapView: UIViewRepresentable {

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
        return mapView
    }

    public func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
    }
    
}
