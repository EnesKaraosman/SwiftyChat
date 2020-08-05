//
//  CellEdgeInsetsModifier.swift
//  
//
//  Created by Enes Karaosman on 4.08.2020.
//

import SwiftUI

public struct CellEdgeInsetsModifier: ViewModifier {
    
    public let isSender: Bool
    @EnvironmentObject var style: ChatMessageCellStyle
    
    private var insets: EdgeInsets? {
        isSender ? style.outgoingCellEdgeInsets : style.incomingCellEdgeInsets
    }
    
    public func body(content: Content) -> some View {
        content.listRowInsets(insets)
    }
    
}
