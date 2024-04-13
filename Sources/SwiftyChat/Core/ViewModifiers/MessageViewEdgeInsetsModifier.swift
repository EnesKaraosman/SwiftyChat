//
//  MessageViewEdgeInsetsModifier.swift
//
//
//  Created by Enes Karaosman on 4.08.2020.
//

import SwiftUI

struct MessageViewEdgeInsetsModifier: ViewModifier {

    let isSender: Bool

    @EnvironmentObject var style: ChatMessageCellStyle

    private var insets: EdgeInsets {
        isSender ? style.outgoingCellEdgeInsets : style.incomingCellEdgeInsets
    }

    func body(content: Content) -> some View {
        content.padding(insets)
    }
}
