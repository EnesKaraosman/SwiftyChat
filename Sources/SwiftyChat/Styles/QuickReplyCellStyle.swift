//
//  QuickReplyCellStyle.swift
//  
//
//  Created by Enes Karaosman on 27.07.2020.
//

import SwiftUI

public struct QuickReplyCellStyle {
    
    /// If the total characters of all item's title is greater than this value, items ordered vertically
    public let characterLimitToChangeStackOrientation: Int
    
    public let selectedItemColor: Color
    public let selectedItemFont: Font
    public let selectedItemFontWeight: Font.Weight
    public let selectedItemBackgroundColor: Color
    
    public let unselectedItemColor: Color
    public let unselectedItemFont: Font
    public let unselectedItemFontWeight: Font.Weight
    public let unselectedItemBackgroundColor: Color
    
    public let itemVerticalPadding: CGFloat
    public let itemHorizontalPadding: CGFloat
    public let itemBorderWidth: CGFloat
    public let itemHeight: CGFloat
    public let itemCornerRadius: CGFloat
    public let itemShadowColor: Color
    public let itemShadowRadius: CGFloat
    
    public init(
        characterLimitToChangeStackOrientation: Int = 30,
        selectedItemColor: Color = .green,
        selectedItemFont: Font = .callout,
        selectedItemFontWeight: Font.Weight = .semibold,
        selectedItemBackgroundColor: Color = Color.green.opacity(0.3),
        unselectedItemColor: Color = .primary,
        unselectedItemFont: Font = .callout,
        unselectedItemFontWeight: Font.Weight = .semibold,
        unselectedItemBackgroundColor: Color = .clear,
        itemVerticalPadding: CGFloat = 8,
        itemHorizontalPadding: CGFloat = 16,
        itemBorderWidth: CGFloat = 1,
        itemHeight: CGFloat = 40,
        itemCornerRadius: CGFloat = 8,
        itemShadowColor: Color = .secondary,
        itemShadowRadius: CGFloat = 1
    ) {
        self.characterLimitToChangeStackOrientation = characterLimitToChangeStackOrientation
        self.selectedItemColor = selectedItemColor
        self.selectedItemFont = selectedItemFont
        self.selectedItemFontWeight = selectedItemFontWeight
        self.selectedItemBackgroundColor = selectedItemBackgroundColor
        self.unselectedItemColor = unselectedItemColor
        self.unselectedItemFont = unselectedItemFont
        self.unselectedItemFontWeight = unselectedItemFontWeight
        self.unselectedItemBackgroundColor = unselectedItemBackgroundColor
        self.itemVerticalPadding = itemVerticalPadding
        self.itemHorizontalPadding = itemHorizontalPadding
        self.itemBorderWidth = itemBorderWidth
        self.itemHeight = itemHeight
        self.itemCornerRadius = itemCornerRadius
        self.itemShadowColor = itemShadowColor
        self.itemShadowRadius = itemShadowRadius
    }
}
