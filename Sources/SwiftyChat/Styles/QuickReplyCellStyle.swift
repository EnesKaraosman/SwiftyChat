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
    public let selectedItemBorderWidth: CGFloat
    public let selectedItemCornerRadius: CGFloat
    public let selectedItemShadowColor: Color
    public let selectedItemShadowRadius: CGFloat
    
    public let unselectedItemColor: Color
    public let unselectedItemFont: Font
    public let unselectedItemFontWeight: Font.Weight
    public let unselectedItemBackgroundColor: Color
    public let unselectedItemBorderWidth: CGFloat
    public let unselectedItemCornerRadius: CGFloat
    public let unselectedItemShadowColor: Color
    public let unselectedItemShadowRadius: CGFloat
    
    public let itemPadding: CGFloat
    public let itemHeight: CGFloat
    
    public init(
        characterLimitToChangeStackOrientation: Int = 30,
        selectedItemColor: Color = .green,
        selectedItemFont: Font = .callout,
        selectedItemFontWeight: Font.Weight = .semibold,
        selectedItemBackgroundColor: Color = Color.green.opacity(0.3),
        selectedItemBorderWidth: CGFloat = 0,
        selectedItemCornerRadius: CGFloat = 8,
        selectedItemShadowColor: Color = .secondary,
        selectedItemShadowRadius: CGFloat = 1,
        unselectedItemColor: Color = .primary,
        unselectedItemFont: Font = .callout,
        unselectedItemFontWeight: Font.Weight = .semibold,
        unselectedItemBackgroundColor: Color = .clear,
        unselectedItemBorderWidth: CGFloat = 0,
        unselectedItemCornerRadius: CGFloat = 8,
        unselectedItemShadowColor: Color = .secondary,
        unselectedItemShadowRadius: CGFloat = 1,
        itemPadding: CGFloat = 8,
        itemHeight: CGFloat = 40
    ) {
        self.characterLimitToChangeStackOrientation = characterLimitToChangeStackOrientation
        self.selectedItemColor = selectedItemColor
        self.selectedItemFont = selectedItemFont
        self.selectedItemFontWeight = selectedItemFontWeight
        self.selectedItemBackgroundColor = selectedItemBackgroundColor
        self.selectedItemBorderWidth = selectedItemBorderWidth
        self.selectedItemCornerRadius = selectedItemCornerRadius
        self.selectedItemShadowColor = selectedItemShadowColor
        self.selectedItemShadowRadius = selectedItemShadowRadius
        self.unselectedItemColor = unselectedItemColor
        self.unselectedItemFont = unselectedItemFont
        self.unselectedItemFontWeight = unselectedItemFontWeight
        self.unselectedItemBackgroundColor = unselectedItemBackgroundColor
        self.unselectedItemBorderWidth = selectedItemBorderWidth
        self.unselectedItemCornerRadius = selectedItemCornerRadius
        self.unselectedItemShadowColor = selectedItemShadowColor
        self.unselectedItemShadowRadius = unselectedItemShadowRadius
        self.itemPadding = itemPadding
        self.itemHeight = itemHeight
    }
    
}
