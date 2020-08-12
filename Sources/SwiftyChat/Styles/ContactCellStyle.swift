//
//  ContactCellStyle.swift
//  
//
//  Created by Enes Karaosman on 7.08.2020.
//

import SwiftUI

public struct ContactCellStyle: CommonViewStyle {
    
    public let cellWidth: (CGSize) -> CGFloat
    public let imageStyle: CommonImageStyle
    public let fullNameLabelStyle: CommonTextStyle
    
    // MARK: - CellContainerStyle
    public let cellBackgroundColor: Color
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color
    
    public init(
        cellWidth: @escaping (CGSize) -> CGFloat = { $0.width * (UIDevice.isLandscape ? 0.45 : 0.75) },
        imageStyle: CommonImageStyle = CommonImageStyle(
            imageSize: CGSize(width: 50, height: 50),
            cornerRadius: 25,
            borderColor: Color.blue.opacity(0.2)
        ),
        fullNameLabelStyle: CommonTextStyle = CommonTextStyle(
            textColor: .primary,
            font: .body,
            fontWeight: .semibold
        ),
        cellBackgroundColor: Color = Color.secondary.opacity(0.05),
        cellCornerRadius: CGFloat = 8,
        cellBorderColor: Color = .clear,
        cellBorderWidth: CGFloat = 1,
        cellShadowRadius: CGFloat = 1,
        cellShadowColor: Color = .secondary
    ) {
        self.cellWidth = cellWidth
        self.imageStyle = imageStyle
        self.fullNameLabelStyle = fullNameLabelStyle
        self.cellBackgroundColor = cellBackgroundColor
        self.cellCornerRadius = cellCornerRadius
        self.cellBorderColor = cellBorderColor
        self.cellBorderWidth = cellBorderWidth
        self.cellShadowRadius = cellShadowRadius
        self.cellShadowColor = cellShadowColor
    }
    
    
}
