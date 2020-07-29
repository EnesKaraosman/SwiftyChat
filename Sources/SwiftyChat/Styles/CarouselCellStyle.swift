//
//  CarouselCellStyle.swift
//  
//
//  Created by Enes Karaosman on 24.07.2020.
//

import UIKit
import SwiftUI

public struct CarouselCellStyle: CellContainerStyle {

    public let titleFont: Font
    public let titleColor: Color
    public let titleFontWeight: Font.Weight
    
    public let subtitleFont: Font
    public let subtitleColor: Color
    public let subtitleFontWeight: Font.Weight
    
    public let buttonFont: Font
    public let buttonTitleColor: Color
    public let buttonTitleFontWeight: Font.Weight
    public let buttonBackgroundColor: Color
    
    /// Cell width in a given available proxy (GeometryReader)
    public let cellWidth: (GeometryProxy) -> CGFloat
    
    // MARK: - CellContainerStyle
    public let cellBackgroundColor: Color
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color
    
    /// UIKit Constructor
    public init(
        titleFont: UIFont = UIFont(name: "Avenir-Black", size: 27)!,
        titleColor: UIColor = .label,
        titleFontWeight: UIFont.Weight = .bold,
        subtitleFont: UIFont = .boldSystemFont(ofSize: 16),
        subtitleColor: UIColor = .secondaryLabel,
        subtitleFontWeight: UIFont.Weight = .regular,
        buttonFont: UIFont = .boldSystemFont(ofSize: 17),
        buttonTitleColor: UIColor = .white,
        buttonBackgroundColor: UIColor = .systemBlue,
        buttonTitleFontWeight: UIFont.Weight = .semibold,
        cellWidth: @escaping (GeometryProxy) -> CGFloat = { $0.size.width * (UIDevice.isLandscape ? 0.6 : 0.7) },
        cellBackgroundColor: UIColor = #colorLiteral(red: 0.9607108235, green: 0.9608257413, blue: 0.9606717229, alpha: 1),
        cellCornerRadius: CGFloat = 8,
        cellBorderColor: UIColor = .clear,
        cellBorderWidth: CGFloat = 0,
        cellShadowRadius: CGFloat = 3,
        cellShadowColor: UIColor = .secondaryLabel
    ) {
        self.titleFont = Font.custom(titleFont.familyName, size: titleFont.pointSize)
        self.titleColor = Color(titleColor)
        self.titleFontWeight = Font.Weight(titleFontWeight)
        self.subtitleFont = Font.custom(subtitleFont.familyName, size: subtitleFont.pointSize)
        self.subtitleColor = Color(subtitleColor)
        self.subtitleFontWeight = Font.Weight(subtitleFontWeight)
        self.buttonFont = Font.custom(buttonFont.familyName, size: buttonFont.pointSize)
        self.buttonTitleColor = Color(buttonTitleColor)
        self.buttonTitleFontWeight = Font.Weight(buttonTitleFontWeight)
        self.buttonBackgroundColor = Color(buttonBackgroundColor)
        self.cellWidth = cellWidth
        self.cellBackgroundColor = Color(cellBackgroundColor)
        self.cellCornerRadius = cellCornerRadius
        self.cellBorderColor = Color(cellBorderColor)
        self.cellBorderWidth = cellBorderWidth
        self.cellShadowRadius = cellShadowRadius
        self.cellShadowColor = Color(cellShadowColor)
    }
    
    /// SwiftUI Constructor
    public init(
        titleFont: Font = Font.title,
        titleColor: Color = .primary,
        titleFontWeight: Font.Weight = .bold,
        subtitleFont: Font = .body,
        subtitleColor: Color = .secondary,
        subtitleFontWeight: Font.Weight = .regular,
        buttonFont: Font = .body,
        buttonTitleColor: Color = .white,
        buttonBackgroundColor: Color = .blue,
        buttonTitleFontWeight: Font.Weight = .semibold,
        cellWidth: @escaping (GeometryProxy) -> CGFloat = { $0.size.width * (UIDevice.isLandscape ? 0.6 : 0.7) },
        cellBackgroundColor: Color = Color(#colorLiteral(red: 0.9607108235, green: 0.9608257413, blue: 0.9606717229, alpha: 1)),
        cellCornerRadius: CGFloat = 8,
        cellBorderColor: Color = .clear,
        cellBorderWidth: CGFloat = 0,
        cellShadowRadius: CGFloat = 3,
        cellShadowColor: Color = .secondary
    ) {
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.titleFontWeight = titleFontWeight
        self.subtitleFont = subtitleFont
        self.subtitleColor = subtitleColor
        self.subtitleFontWeight = subtitleFontWeight
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
