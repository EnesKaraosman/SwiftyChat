//
//  CarouselCellStyle.swift
//  
//
//  Created by Enes Karaosman on 24.07.2020.
//

import UIKit
import SwiftUI

public struct CarouselCellStyle {

    public let imageSize: CGSize
    
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
    
    public let cellContainerBackgroundColor: Color
    public let cellContainerCornerRadius: CGFloat
    
    /// UIKit Constructor
    public init(
        imageSize: CGSize = .init(width: 220, height: 220),
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
        cellContainerBackgroundColor: UIColor = #colorLiteral(red: 0.9607108235, green: 0.9608257413, blue: 0.9606717229, alpha: 1),
        cellContainerCornerRadius: CGFloat = 8
    ) {
        self.imageSize = imageSize
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
        self.cellContainerBackgroundColor = Color(cellContainerBackgroundColor)
        self.cellContainerCornerRadius = cellContainerCornerRadius
    }
    
    /// SwiftUI Constructor
    public init(
        imageSize: CGSize = .init(width: 220, height: 220),
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
        cellContainerBackgroundColor: Color = Color(#colorLiteral(red: 0.9607108235, green: 0.9608257413, blue: 0.9606717229, alpha: 1)),
        cellContainerCornerRadius: CGFloat = 8
    ) {
        self.imageSize = imageSize
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
        self.cellContainerBackgroundColor = cellContainerBackgroundColor
        self.cellContainerCornerRadius = cellContainerCornerRadius
    }
    
}
