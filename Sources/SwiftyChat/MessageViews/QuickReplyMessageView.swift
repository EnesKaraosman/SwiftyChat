//
//  QuickReplyMessageView.swift
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
import WrappingHStack

struct QuickReplyMessageView: View {

    let quickReplies: [QuickReplyItem]
    let quickReplySelected: (QuickReplyItem) -> Void
    @EnvironmentObject var style: ChatMessageCellStyle

    private var cellStyle: QuickReplyCellStyle {
        style.quickReplyCellStyle
    }

    @State private var isDisabled = false
    @State private var selectedIndex: Int?

    private func itemColor(for index: Int) -> Color {
        index == selectedIndex ? cellStyle.selectedItemColor : cellStyle.unselectedItemColor
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
            Button(action: {}, label: {
                Text(quickReplies[idx].title)
                    .fontWeight(
                        idx == selectedIndex ?
                            cellStyle.selectedItemFontWeight : cellStyle.unselectedItemFontWeight
                    )
                    .font(idx == selectedIndex ? cellStyle.selectedItemFont : cellStyle.unselectedItemFont)
                    .padding(.vertical, cellStyle.itemVerticalPadding)
                    .padding(.horizontal, cellStyle.itemHorizontalPadding)
                    .frame(height: cellStyle.itemHeight)
                    .background(itemBackground(for: idx))
                    .foregroundColor(itemColor(for: idx))
                    .overlay(
                        RoundedRectangle(cornerRadius: cellStyle.itemCornerRadius)
                            .stroke(
                                itemColor(for: idx),
                                lineWidth: cellStyle.itemBorderWidth
                            )
                            .shadow(
                                color: cellStyle.itemShadowColor,
                                radius: cellStyle.itemShadowRadius,
                                x: 0, y: 4
                            )
                    )
            })
            .simultaneousGesture(
                TapGesture().onEnded { _ in
                    selectedIndex = idx
                    isDisabled = true
                    quickReplySelected(quickReplies[idx])
                }
            )
            .padding(.vertical, 4)
        }
        .disabled(isDisabled)
        .fixedSize(horizontal: false, vertical: true)
    }
}
