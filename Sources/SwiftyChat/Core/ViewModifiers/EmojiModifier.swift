//
//  EmojiModifier.swift
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

/// Modifies text font if contains emoji
struct EmojiModifier: ViewModifier {

    let text: String
    let defaultFont: Font

    private var font: Font {
        if text.containsOnlyEmoji {
            switch text.count {
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
