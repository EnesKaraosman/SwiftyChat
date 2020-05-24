//
//  String++.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import UIKit

/// Emoji helper
internal extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

internal extension String {
    var isSingleEmoji: Bool { count == 1 && containsEmoji }

    var containsEmoji: Bool { contains { $0.isEmoji } }

    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

    var emojiString: String { emojis.map { String($0) }.reduce("", +) }

    var emojis: [Character] { filter { $0.isEmoji } }

    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}

internal extension String {
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ) else { return nil }
        return html
    }
    func containsHtml() -> Bool {
        
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: #"<\/?[a-z][\s\S]*>"#)
        
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
}

internal extension NSAttributedString {
    func htmlString() -> String? {
        do {
            let htmlData = try self.data(
                from: NSMakeRange(0, self.length),
                documentAttributes: [.documentType: NSAttributedString.DocumentType.html]
            )
            if let htmlString = String(data:htmlData, encoding:String.Encoding.utf8) { return htmlString }
        }
        catch {}
        return nil
    }
    func newAttrSize(fontSize: CGFloat) -> NSAttributedString {
        let yourAttrStr = NSMutableAttributedString(attributedString: self)
        yourAttrStr.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: fontSize),
            range: NSMakeRange(0, yourAttrStr.length)
        )
        return yourAttrStr
    }
    
}
