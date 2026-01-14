//
//  EmojiModifier.swift
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

/// Modifies text font if contains emoji
struct EmojiModifier: ViewModifier {

    let isEmojiOnly: Bool
    let emojiCount: Int
    let defaultFont: Font
    
    init(isEmojiOnly: Bool, emojiCount: Int = 0, defaultFont: Font) {
        self.isEmojiOnly = isEmojiOnly
        self.emojiCount = emojiCount
        self.defaultFont = defaultFont
    }
    
    // Convenience initializer for text-based checking
    init(text: String, defaultFont: Font) {
        self.isEmojiOnly = text.containsOnlyEmoji
        self.emojiCount = text.count
        self.defaultFont = defaultFont
    }

    private var font: Font {
        if isEmojiOnly {
            switch emojiCount {
            case 1: return .system(size: 50)
            case 2: return .system(size: 38)
            case 3: return .system(size: 25)
            default: return defaultFont
            }
        }

        return defaultFont
    }

    func body(content: Content) -> some View {
        content.font(font)
    }
}
