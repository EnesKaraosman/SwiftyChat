//
//  ImageCellStyle.swift
//
//
//  Created by Enes Karaosman on 29.07.2020.
//

import SwiftUI

public struct ImageCellStyle: CommonViewStyle {

    public var cellWidth: (CGSize) -> CGFloat

    // MARK: - CellContainerStyles
    public let cellBackgroundColor: Color
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color

    public init(
        cellWidth: @escaping (CGSize) -> CGFloat = { size in
            if !Device.isLandscape {
                return size.width * 0.75
            }
            return size.height * 0.8
        },
        cellBackgroundColor: Color = Color.secondary.opacity(0.1),
        cellCornerRadius: CGFloat = 8,
        cellBorderColor: Color = .clear,
        cellBorderWidth: CGFloat = 0,
        cellShadowRadius: CGFloat = 3,
        cellShadowColor: Color = .secondary
    ) {
        self.cellWidth = cellWidth
        self.cellBackgroundColor = cellBackgroundColor
        self.cellCornerRadius = cellCornerRadius
        self.cellBorderColor = cellBorderColor
        self.cellBorderWidth = cellBorderWidth
        self.cellShadowRadius = cellShadowRadius
        self.cellShadowColor = cellShadowColor
    }
}
