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
            ForEach(0..<quickReplies.count) { idx in

                Button(action: {}) {
                    Text(self.quickReplies[idx].title)
                        .fontWeight(
                            idx == self.selectedIndex ? self.cellStyle.selectedItemFontWeight : self.cellStyle.unselectedItemFontWeight
                        )
                        .font(
                            idx == self.selectedIndex ? self.cellStyle.selectedItemFont : self.cellStyle.unselectedItemFont
                        )
                        .padding(self.cellStyle.itemPadding)
                        .frame(height: self.cellStyle.itemHeight)
                        .background(self.itemBackground(for: idx))
                        .foregroundColor(self.colors(selectedIndex: self.selectedIndex)[idx])
                        .overlay(
                            RoundedRectangle(cornerRadius: self.cellStyle.itemCornerRadius)
                                .stroke(
                                    self.colors(selectedIndex: self.selectedIndex)[idx],
                                    lineWidth: idx == self.selectedIndex ?
                                        self.cellStyle.selectedItemBorderWidth :
                                        self.cellStyle.unselectedItemBorderWidth
                                )
                                .shadow(
                                    color: idx == self.selectedIndex ?
                                        self.cellStyle.selectedItemShadowColor :
                                        self.cellStyle.unselectedItemShadowColor,
                                    radius: idx == self.selectedIndex ?
                                        self.cellStyle.selectedItemShadowRadius :
                                        self.cellStyle.unselectedItemShadowRadius
                                )
                        )
                }
                .simultaneousGesture(
                    TapGesture().onEnded { _ in
                        self.selectedIndex = idx
                        self.isDisabled = true
                        self.quickReplySelected(self.quickReplies[idx])
                    }
                )
                
            }
        }.disabled(isDisabled)
    }
    
}
