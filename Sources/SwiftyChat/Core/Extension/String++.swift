//
//  String++.swift
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

/// Emoji helper
extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    private var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    /// Checks if the scalars will be merged into an emoji
    private var isCombinedIntoEmoji: Bool {
        unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
    }

    fileprivate var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

    private var isSingleEmoji: Bool { count == 1 && containsEmoji }

    private var containsEmoji: Bool { contains { $0.isEmoji } }

    private var emojiString: String { emojis.map { String($0) }.reduce("", +) }

    private var emojis: [Character] { filter { $0.isEmoji } }

    private var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}
