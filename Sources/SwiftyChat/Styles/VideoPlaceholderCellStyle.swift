//
//  Video.swift
//  
//
//  Created by Enes Karaosman on 6.11.2020.
//

import SwiftUI

public struct VideoPlaceholderCellStyle {
    
    public var cellWidth: (CGSize) -> CGFloat
    
    public let cellBackgroundColor: Color
    public let cellAspectRatio: CGFloat
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color
    public let cellBlurRadius: CGFloat
    
    public init(
        cellWidth: @escaping (CGSize) -> CGFloat = { $0.width * (UIDevice.isLandscape ? 0.4 : 0.75) },
        cellBackgroundColor: Color = Color.secondary.opacity(0.1),
        cellAspectRatio:  CGFloat = 1.78,
        cellCornerRadius: CGFloat = 8,
        cellBorderColor:  Color = .clear,
        cellBorderWidth:  CGFloat = 0,
        cellShadowRadius: CGFloat = 2,
        cellShadowColor:  Color = .secondary,
        cellBlurRadius: CGFloat = 3
    ) {
        self.cellWidth = cellWidth
        self.cellBackgroundColor = cellBackgroundColor
        self.cellAspectRatio = cellAspectRatio
        self.cellCornerRadius = cellCornerRadius
        self.cellBorderColor = cellBorderColor
        self.cellBorderWidth = cellBorderWidth
        self.cellShadowRadius = cellShadowRadius
        self.cellShadowColor = cellShadowColor
        self.cellBlurRadius = cellBlurRadius
    }
    
}

