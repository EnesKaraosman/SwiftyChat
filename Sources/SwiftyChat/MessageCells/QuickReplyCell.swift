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
    
    private func color(for index: Int, selectedIndex: Int?) -> Color {
        let colors = self.colors(selectedIndex: selectedIndex)
        let count = colors.count
        if index >= count {
            return colors[index % count]
        }
        return colors[index]
    }
    
    private func colors(selectedIndex: Int?) -> [Color] {
        let colorMatrix = (1...quickReplies.count).map { idx -> [Color] in
            if let selectedIndex = selectedIndex, idx == selectedIndex {
                return [self.cellStyle.selectedItemColor]
            }
            let colorMatrix: [[Color]] = self.cellStyle.unselectedItemColor
            let count = colorMatrix.count
            if idx >= count {
                return colorMatrix[idx % count]
            }
            let itemColors = colorMatrix[idx]
            return itemColors
        }
        
        return colorMatrix[selectedIndex ?? 0]
    }
    
    private func itemBackground(for index: Int) -> some View {
        let isSelected = index == self.selectedIndex
        guard !isSelected else {
            return cellStyle.selectedItemBackgroundColor
                .cornerRadius(self.cellStyle.selectedItemCornerRadius)
        }
        
        let colorMatrix: [[Color]] = self.cellStyle.unselectedItemBackgroundColor
        let count = colorMatrix.count
        
        let backgroundColors: [Color]
        if index >= count {
            backgroundColors = colorMatrix[index % count]
        } else {
            backgroundColors = colorMatrix[count - 1]
        }
        
        let backgroundColor = backgroundColors[index]
        
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
                let borderColor: Color = isSelected ?
                        self.cellStyle.selectedItemBorderColor :
                        .clear
                let shadowColor: Color = isSelected ?
                    self.cellStyle.selectedItemShadowColor :
                    self.cellStyle.unselectedItemShadowColor
                let shadowRadius: CGFloat = isSelected ?
                    self.cellStyle.selectedItemShadowRadius :
                    self.cellStyle.unselectedItemShadowRadius
                let cornerRadius: CGFloat = isSelected ?
                    self.cellStyle.selectedItemCornerRadius :
                    self.cellStyle.unselectedItemCornerRadius
                
                let color = self.color(for: idx, selectedIndex: self.selectedIndex)
                let button =
                    Button(action: {}) {
                        Text(self.quickReplies[idx].title)
                            .fontWeight(fontWeight)
                            .font(font)
                            .padding(self.cellStyle.itemPadding)
                            .frame(width: self.cellStyle.itemWidth, height: self.cellStyle.itemHeight)
                            .background(self.itemBackground(for: idx))
                            .foregroundColor(color)
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(
                                        borderColor,
                                        lineWidth: borderWidth
                                    )
                                    .shadow(color: shadowColor, radius: shadowRadius)
                            )
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded { _ in
                            withAnimation {
                                self.selectedIndex = idx
                                self.isDisabled = true
                                self.quickReplySelected(self.quickReplies[idx])
                            }
                        }
                    )
                
                return AnyView(button)
                
            }
        }.disabled(isDisabled)
    }
    
}
