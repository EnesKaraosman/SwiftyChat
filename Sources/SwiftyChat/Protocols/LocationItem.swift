//
//  File.swift
//  
//
//  Created by Enes Karaosman on 25.05.2020.
//

import Foundation

/// Represents the data for a location.
public protocol LocationItem {
    
    /// Latitude of pin
    var latitude: Double { get }
    
    /// Longitude of pin
    var longitude: Double { get }
    
}
