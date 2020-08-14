//
//  TextCellStyle.swift
//  
//
//  Created by Enes Karaosman on 12.08.2020.
//

import SwiftUI

public struct TextCellStyle: CommonViewStyle {
    
    public let textStyle: CommonTextStyle
    public let textPadding: CGFloat
    
    public let attributedTextStyle: AttributedTextStyle
    
    // MARK: - CellContainerStyle
    public let cellBackgroundColor: Color
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color
    
    public init(
        textStyle: CommonTextStyle = CommonTextStyle(
            textColor: .white,
            font: .body,
            fontWeight: .regular
        ),
        textPadding: CGFloat = 10,
        attributedTextStyle: AttributedTextStyle = AttributedTextStyle(),
        cellBackgroundColor: Color = Color(UIColor.systemPurple).opacity(0.8),
        cellCornerRadius: CGFloat = 8,
        cellBorderColor: Color = .clear,
        cellBorderWidth: CGFloat = 1,
        cellShadowRadius: CGFloat = 3,
        cellShadowColor: Color = .secondary
    ) {
        self.textStyle = textStyle
        self.textPadding = textPadding
        self.attributedTextStyle = attributedTextStyle
        self.cellBackgroundColor = cellBackgroundColor
        self.cellCornerRadius = cellCornerRadius
        self.cellBorderColor = cellBorderColor
        self.cellBorderWidth = cellBorderWidth
        self.cellShadowRadius = cellShadowRadius
        self.cellShadowColor = cellShadowColor
    }
    
}
