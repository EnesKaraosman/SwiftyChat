//
//  EmojiModifier.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

/// Modifies the content if text contains emoji
internal struct EmojiModifier: ViewModifier {
    
    public let text: String
    public let defaultFont: Font

    private var font: Font? {
        var _font: Font = self.defaultFont
        if text.containsOnlyEmoji {
            let count = text.count
            switch count {
            case 1: _font = .system(size: 50)
            case 2: _font = .system(size: 38)
            case 3: _font = .system(size: 25)
            default: _font = self.defaultFont
            }
        }
        return _font
    }
    
    public func body(content: Content) -> some View {
        content.font(font)
    }
    
}
