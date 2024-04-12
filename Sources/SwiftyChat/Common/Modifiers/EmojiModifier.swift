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

    let text: String
    let defaultFont: Font

    private var font: Font? {
        var modifiedFont: Font = defaultFont
        if text.containsOnlyEmoji {
            let count = text.count
            switch count {
            case 1: modifiedFont = .system(size: 50)
            case 2: modifiedFont = .system(size: 38)
            case 3: modifiedFont = .system(size: 25)
            default: modifiedFont = defaultFont
            }
        }

        return modifiedFont
    }

    func body(content: Content) -> some View {
        content.font(font)
    }
}
