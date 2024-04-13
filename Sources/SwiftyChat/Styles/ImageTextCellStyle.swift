//
//  ImageTextCellStyle.swift
//
//
//  Created by Karl Söderberg on 25.10.2021.
//

import SwiftUI

public struct ImageTextCellStyle: CommonViewStyle {

    public let textStyle: CommonTextStyle
    public let textPadding: CGFloat
    public let cellWidth: (CGSize) -> CGFloat

    // MARK: - CellContainerStyles
    public let cellBackgroundColor: Color
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color
    public let cellRoundedCorners: RectCorner

    public init(
        textStyle: CommonTextStyle = CommonTextStyle(
            textColor: .white,
            font: .body,
            fontWeight: .regular
        ),
        textPadding: CGFloat = 10,
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
        cellShadowColor: Color = .secondary,
        cellRoundedCorners: RectCorner = .allCorners
    ) {
        self.textStyle = textStyle
        self.textPadding = textPadding
        self.cellWidth = cellWidth
        self.cellBackgroundColor = cellBackgroundColor
        self.cellCornerRadius = cellCornerRadius
        self.cellBorderColor = cellBorderColor
        self.cellBorderWidth = cellBorderWidth
        self.cellShadowRadius = cellShadowRadius
        self.cellShadowColor = cellShadowColor
        self.cellRoundedCorners = cellRoundedCorners
    }
}
