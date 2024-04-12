//
//  CarouselCellStyle.swift
//
//
//  Created by Enes Karaosman on 24.07.2020.
//

import SwiftUI

public struct CarouselCellStyle: CommonViewStyle {

    public let titleLabelStyle: CommonTextStyle
    public let subtitleLabelStyle: CommonTextStyle

    public let buttonFont: Font
    public let buttonTitleColor: Color
    public let buttonTitleFontWeight: Font.Weight
    public let buttonBackgroundColor: Color

    /// Cell width in a given available proxy (GeometryReader)
    public let cellWidth: (CGSize) -> CGFloat

    // MARK: - CellContainerStyle
    public let cellBackgroundColor: Color
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color

    public init(
        titleLabelStyle: CommonTextStyle = CommonTextStyle(
            textColor: .primary,
            font: .title,
            fontWeight: .bold
        ),
        subtitleLabelStyle: CommonTextStyle = CommonTextStyle(
            textColor: .secondary,
            font: .body
        ),
        buttonFont: Font = .body,
        buttonTitleColor: Color = .white,
        buttonBackgroundColor: Color = .blue,
        buttonTitleFontWeight: Font.Weight = .semibold,
        cellWidth: @escaping (CGSize) -> CGFloat = { $0.width * (Device.isLandscape ? 0.4 : 0.75) },
        cellBackgroundColor: Color = Color.secondary.opacity(0.1),
        cellCornerRadius: CGFloat = 8,
        cellBorderColor: Color = .clear,
        cellBorderWidth: CGFloat = 1,
        cellShadowRadius: CGFloat = 3,
        cellShadowColor: Color = .secondary
    ) {
        self.titleLabelStyle = titleLabelStyle
        self.subtitleLabelStyle = subtitleLabelStyle
        self.buttonFont = buttonFont
        self.buttonTitleColor = buttonTitleColor
        self.buttonTitleFontWeight = buttonTitleFontWeight
        self.buttonBackgroundColor = buttonBackgroundColor
        self.cellWidth = cellWidth
        self.cellBackgroundColor = cellBackgroundColor
        self.cellCornerRadius = cellCornerRadius
        self.cellBorderColor = cellBorderColor
        self.cellBorderWidth = cellBorderWidth
        self.cellShadowRadius = cellShadowRadius
        self.cellShadowColor = cellShadowColor
    }

}
