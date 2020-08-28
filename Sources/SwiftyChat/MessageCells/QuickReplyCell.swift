//
//  QuickReplyCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public struct QuickReplyCell: View {
    
    public var quickReplies: [QuickReplyItem]
    public var quickReplySelected: (QuickReplyItem) -> Void
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var totalOptionsLength: Int {
        quickReplies.map { $0.title.count }.reduce(0, +)
    }
    
    private var cellStyle: QuickReplyCellStyle {
        style.quickReplyCellStyle
    }
    
    @State private var isDisabled = false
    @State private var selectedIndex: Int?
    
    private func colors(selectedIndex: Int?) -> [Color] {
        var colors = (1...quickReplies.count).map { _ in cellStyle.unselectedItemColor }
        if let idx = selectedIndex {
            colors[idx] = cellStyle.selectedItemColor
        }
        return colors
    }
    
    private func itemBackground(for index: Int) -> some View {
        let backgroundColor: Color = (index == self.selectedIndex ? self.cellStyle.selectedItemBackgroundColor : self.cellStyle.unselectedItemBackgroundColor)
        
        return backgroundColor.cornerRadius(index == self.selectedIndex ?
            self.cellStyle.selectedItemCornerRadius :
            self.cellStyle.unselectedItemCornerRadius
        )
    }
    
    public var body: some View {
        conditionalStack(isVStack: totalOptionsLength > self.cellStyle.characterLimitToChangeStackOrientation) {
            return ForEach(0..<quickReplies.count) { idx -> AnyView in

                let isSelected: Bool = idx == self.selectedIndex
                let fontWeight: Font.Weight = isSelected ?
                    self.cellStyle.selectedItemFontWeight :
                    self.cellStyle.unselectedItemFontWeight
                let font: Font = isSelected ?
                    self.cellStyle.selectedItemFont :
                    self.cellStyle.unselectedItemFont
                let borderWidth: CGFloat = isSelected ?
                    self.cellStyle.selectedItemBorderWidth :
                    self.cellStyle.unselectedItemBorderWidth
                let shadowColor: Color = isSelected ?
                    self.cellStyle.selectedItemShadowColor :
                    self.cellStyle.unselectedItemShadowColor
                let shadowRadius: CGFloat = isSelected ?
                    self.cellStyle.selectedItemShadowRadius :
                    self.cellStyle.unselectedItemShadowRadius
                let cornerRadius: CGFloat = isSelected ?
                    self.cellStyle.selectedItemCornerRadius :
                    self.cellStyle.unselectedItemCornerRadius
                
                
                let button =
                    Button(action: {}) {
                        Text(self.quickReplies[idx].title)
                            .fontWeight(fontWeight)
                            .font(font)
                            .padding(self.cellStyle.itemPadding)
                            .frame(height: self.cellStyle.itemHeight)
                            .background(self.itemBackground(for: idx))
                            .foregroundColor(self.colors(selectedIndex: self.selectedIndex)[idx])
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(
                                        self.colors(selectedIndex: self.selectedIndex)[idx],
                                        lineWidth: borderWidth
                                    )
                                    .shadow(color: shadowColor, radius: shadowRadius)
                            )
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded { _ in
                            self.selectedIndex = idx
                            self.isDisabled = true
                            self.quickReplySelected(self.quickReplies[idx])
                        }
                    )
                
                return AnyView(button)
                
            }
        }.disabled(isDisabled)
    }
    
}
