//
//  QuickReplyCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public struct QuickReplyItem {
    public let id = UUID()
    public var title: String
    public var payload: String
    
    public init(title: String, payload: String) {
        self.title = title
        self.payload = payload
    }
}


// MARK: - QuickReplyCell
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
    
    public var body: some View {
        conditionalStack(isVStack: totalOptionsLength > 30) {
            ForEach(0..<quickReplies.count) { idx in

                Button(action: {}) {
                    Text(self.quickReplies[idx].title)
                        .fontWeight(
                            idx == selectedIndex ? cellStyle.selectedItemFontWeight : cellStyle.unselectedItemFontWeight
                        )
                        .font(
                            idx == selectedIndex ? cellStyle.selectedItemFont : cellStyle.unselectedItemFont
                        )
                        .padding(cellStyle.padding)
                        .foregroundColor(self.colors(selectedIndex: self.selectedIndex)[idx])
                        .overlay(
                            Capsule()
                                .stroke(
                                    self.colors(selectedIndex: self.selectedIndex)[idx],
                                    lineWidth: cellStyle.lineWidth
                                )
                                .shadow(color: Color.secondary, radius: 1)
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
