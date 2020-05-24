//
//  EmojiModifier.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 22.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

/// Modifies the content if text contains emoji
public struct EmojiModifier: ViewModifier {
    
    public let text: String

    private var font: Font? {
        var _font: Font?
        if text.containsOnlyEmoji {
            let count = text.count
            switch count {
            case 1:
                _font = .system(size: 50)
            case 2:
                _font = .system(size: 38)
            case 3:
                _font = .system(size: 25)
            default:
                _font = .body
            }
        }
        return _font
    }
    
    public func body(content: Content) -> some View {
        return content
        .font(font)
    }
    
}
