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
        var font: Font = defaultFont
        if text.containsOnlyEmoji {
            let count = text.count
            switch count {
            case 1: font = .system(size: 50)
            case 2: font = .system(size: 38)
            case 3: font = .system(size: 25)
            default: font = defaultFont
            }
        }

        return font
    }

    func body(content: Content) -> some View {
        content.font(font)
    }
}
