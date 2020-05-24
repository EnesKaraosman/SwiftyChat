//
//  QuickReplyCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public struct QuickReply {
    public let id = UUID()
    public var title: String
    public var payload: String
}


// MARK: - QuickReplyCell
public struct QuickReplyCell: View {
    
    public var quickReplies: [QuickReply]
    public var quickReplySelected: (QuickReply) -> Void
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var totalOptionsLength: Int {
        quickReplies.map { $0.title.count }.reduce(0, +)
    }
    
    @State private var isDisabled = false
    @State private var selectedIndex: Int?
    
    private func colors(selectedIndex: Int?) -> [Color] {
        var colors = (1...quickReplies.count).map { _ in style.quickReplyUnselectedItemColor }
        if let idx = selectedIndex {
            colors[idx] = style.quickReplySelectedItemColor
        }
        return colors
    }
    
    public var body: some View {
        conditionalStack(isVStack: totalOptionsLength > 30) {
            ForEach(0..<quickReplies.count) { idx in

                Button(action: {}) {
                    Text(self.quickReplies[idx].title)
                        .font(.callout)
                        .padding(8)
                        .foregroundColor(self.colors(selectedIndex: self.selectedIndex)[idx])
                        .overlay(
                            Capsule()
                                .stroke(
                                    self.colors(selectedIndex: self.selectedIndex)[idx],
                                    lineWidth: 2
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
