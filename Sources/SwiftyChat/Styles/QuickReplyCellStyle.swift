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
    
    public let itemPadding: CGFloat
    public let itemBorderWidth: CGFloat
    public let itemHeight: CGFloat
    public let itemCornerRadius: CGFloat
    public let itemShadowColor: Color
    public let itemShadowRadius: CGFloat
    
    /// UIKit constructor
    public init(
        characterLimitToChangeStackOrientation: Int = 30,
        selectedItemColor: UIColor = .systemGreen,
        selectedItemFont: UIFont = .systemFont(ofSize: 16),
        selectedItemFontWeight: UIFont.Weight = .semibold,
        selectedItemBackgroundColor: UIColor = UIColor.systemGreen.withAlphaComponent(0.3),
        unselectedItemColor: UIColor = .label,
        unselectedItemFont: UIFont = .systemFont(ofSize: 16),
        unselectedItemFontWeight: UIFont.Weight = .regular,
        unselectedItemBackgroundColor: UIColor = .clear,
        itemPadding: CGFloat = 8,
        itemBorderWidth: CGFloat = 1,
        itemHeight: CGFloat = 40,
        itemCornerRadius: CGFloat = 8,
        itemShadowColor: UIColor = .secondaryLabel,
        itemShadowRadius: CGFloat = 1
    ) {
        self.characterLimitToChangeStackOrientation = characterLimitToChangeStackOrientation
        self.selectedItemColor = Color(selectedItemColor)
        self.selectedItemFont = Font.custom(selectedItemFont.familyName, size: selectedItemFont.pointSize)
        self.selectedItemFontWeight = Font.Weight(selectedItemFontWeight)
        self.selectedItemBackgroundColor = Color(selectedItemBackgroundColor)
        self.unselectedItemColor = Color(unselectedItemColor)
        self.unselectedItemFont = Font.custom(unselectedItemFont.familyName, size: selectedItemFont.pointSize)
        self.unselectedItemFontWeight = Font.Weight(unselectedItemFontWeight)
        self.unselectedItemBackgroundColor = Color(unselectedItemBackgroundColor)
        self.itemPadding = itemPadding
        self.itemBorderWidth = itemBorderWidth
        self.itemHeight = itemHeight
        self.itemCornerRadius = itemCornerRadius
        self.itemShadowColor = Color(itemShadowColor)
        self.itemShadowRadius = itemShadowRadius
    }
    
    /// SwiftUI constructor
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
        itemPadding: CGFloat = 8,
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
        self.itemPadding = itemPadding
        self.itemBorderWidth = itemBorderWidth
        self.itemHeight = itemHeight
        self.itemCornerRadius = itemCornerRadius
        self.itemShadowColor = itemShadowColor
        self.itemShadowRadius = itemShadowRadius
    }
    
}
