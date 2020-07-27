//
//  QuickReplyCellStyle.swift
//  
//
//  Created by Enes Karaosman on 27.07.2020.
//

import SwiftUI

public struct QuickReplyCellStyle {
    
    public let selectedItemColor: Color
    public let selectedItemFont: Font
    public let selectedItemFontWeight: Font.Weight
    
    public let unselectedItemColor: Color
    public let unselectedItemFont: Font
    public let unselectedItemFontWeight: Font.Weight
    
    public let padding: CGFloat
    public let lineWidth: CGFloat
    
    /// UIKit constructor
    public init(
        selectedItemColor: UIColor = .systemGreen,
        selectedItemFont: UIFont = .systemFont(ofSize: 16),
        selectedItemFontWeight: UIFont.Weight = .semibold,
        unselectedItemColor: UIColor = .label,
        unselectedItemFont: UIFont = .systemFont(ofSize: 16),
        unselectedItemFontWeight: UIFont.Weight = .regular,
        padding: CGFloat = 8,
        lineWidth: CGFloat = 1
    ) {
        self.selectedItemColor = Color(selectedItemColor)
        self.selectedItemFont = Font.custom(selectedItemFont.familyName, size: selectedItemFont.pointSize)
        self.selectedItemFontWeight = Font.Weight(selectedItemFontWeight)
        self.unselectedItemColor = Color(unselectedItemColor)
        self.unselectedItemFont = Font.custom(unselectedItemFont.familyName, size: selectedItemFont.pointSize)
        self.unselectedItemFontWeight = Font.Weight(unselectedItemFontWeight)
        self.padding = padding
        self.lineWidth = lineWidth
    }
    
    /// SwiftUI constructor
    public init(
        selectedItemColor: Color = .green,
        selectedItemFont: Font = .callout,
        selectedItemFontWeight: Font.Weight = .semibold,
        unselectedItemColor: Color = .primary,
        unselectedItemFont: Font = .callout,
        unselectedItemFontWeight: Font.Weight = .semibold,
        padding: CGFloat = 8,
        lineWidth: CGFloat = 1
    ) {
        self.selectedItemColor = selectedItemColor
        self.selectedItemFont = selectedItemFont
        self.selectedItemFontWeight = selectedItemFontWeight
        self.unselectedItemColor = unselectedItemColor
        self.unselectedItemFont = unselectedItemFont
        self.unselectedItemFontWeight = unselectedItemFontWeight
        self.padding = padding
        self.lineWidth = lineWidth
    }
    
}
