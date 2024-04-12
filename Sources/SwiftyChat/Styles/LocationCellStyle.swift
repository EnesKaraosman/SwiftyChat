//
//  LocationCellStyle.swift
//
//
//  Created by Enes Karaosman on 5.08.2020.
//

import SwiftUI

public struct LocationCellStyle {

    public let cellWidth: (CGSize) -> CGFloat
    public let cellAspectRatio: CGFloat
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color

    public init(
        cellWidth: @escaping (CGSize) -> CGFloat = { $0.width * (Device.isLandscape ? 0.4 : 0.75) },
        cellAspectRatio: CGFloat = 0.7,
        cellCornerRadius: CGFloat = 8,
        cellBorderColor: Color = .clear,
        cellBorderWidth: CGFloat = 0,
        cellShadowRadius: CGFloat = 2,
        cellShadowColor: Color = .secondary
    ) {
        self.cellWidth = cellWidth
        self.cellAspectRatio = cellAspectRatio
        self.cellCornerRadius = cellCornerRadius
        self.cellBorderColor = cellBorderColor
        self.cellBorderWidth = cellBorderWidth
        self.cellShadowRadius = cellShadowRadius
        self.cellShadowColor = cellShadowColor
    }
}
