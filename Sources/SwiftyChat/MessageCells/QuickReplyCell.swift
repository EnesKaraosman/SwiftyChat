//
//  QuickReplyCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
import WrappingHStack

internal struct QuickReplyCell: View {

    var quickReplies: [QuickReplyItem]
    var quickReplySelected: (QuickReplyItem) -> Void
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
        let backgroundColor = index == selectedIndex ?
            cellStyle.selectedItemBackgroundColor :
            cellStyle.unselectedItemBackgroundColor
        return Capsule().foregroundColor(backgroundColor)
    }

    var body: some View {
        // TODO: Custom `Layout` can be used when min iOS target hits 16.0
        WrappingHStack(0..<quickReplies.count, id: \.self, alignment: .trailing, spacing: .constant(8)) { idx in

            Button(action: {}) {
                Text(quickReplies[idx].title)
                    .fontWeight(idx == selectedIndex ? cellStyle.selectedItemFontWeight : cellStyle.unselectedItemFontWeight)
                    .font(idx == selectedIndex ? cellStyle.selectedItemFont : cellStyle.unselectedItemFont)
                    .padding(.vertical, cellStyle.itemVerticalPadding)
                    .padding(.horizontal, cellStyle.itemHorizontalPadding)
                    .frame(height: cellStyle.itemHeight)
                    .background(itemBackground(for: idx))
                    .foregroundColor(colors(selectedIndex: selectedIndex)[idx])
                    .overlay(
                        Capsule()
                            .stroke(
                                colors(selectedIndex: selectedIndex)[idx],
                                lineWidth: cellStyle.itemBorderWidth)
                            .shadow(color: cellStyle.itemShadowColor,
                                    radius: cellStyle.itemShadowRadius,
                                    x: 0,
                                    y: 4))
            }
            .simultaneousGesture(
                TapGesture().onEnded { _ in
                    selectedIndex = idx
                    isDisabled = true
                    quickReplySelected(quickReplies[idx])
                }
            )
            .padding(.vertical, 4)
        }.disabled(isDisabled)
    }
}
