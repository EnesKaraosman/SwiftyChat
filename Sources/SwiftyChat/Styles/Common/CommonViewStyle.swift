//
//  CellContainerStyle.swift
//  
//
//  Created by Enes Karaosman on 29.07.2020.
//

import SwiftUI

internal protocol CommonViewStyle {
    var cellBackgroundColor: Color { get }
    var cellCornerRadius: CGFloat { get }
    var cellBorderColor: Color { get }
    var cellBorderWidth: CGFloat { get }
    var cellShadowRadius: CGFloat { get }
    var cellShadowColor: Color { get }
}
