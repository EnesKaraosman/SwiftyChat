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
    
    var cleanHtml: String {
        // Convert the HTML string to Data
        guard let data = self.data(using: .utf8) else {
            return self // Return original string if conversion fails
        }

        // Try to convert the HTML data to an attributed string
        if let attributedString = try? NSAttributedString(data: data,
                                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                                          documentAttributes: nil) {
            // Return the plain string from the attributed string
            return attributedString.string
        } else {
            return self // Return original string if conversion fails
        }
    }
    
    func containsEscapedHtml() -> Bool {
        return self.contains("&lt;") || self.contains("&gt;")
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    func containsHtml() -> Bool {
        
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: #"<\/?[a-z][\s\S]*>"#)
        
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    func frameSize(maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) -> CGSize {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .body)
        ]
        let attributedText = NSAttributedString(string: self, attributes: attributes)
        let width = maxWidth != nil ? min(maxWidth!, CGFloat.greatestFiniteMagnitude) : CGFloat.greatestFiniteMagnitude
        let height = maxHeight != nil ? min(maxHeight!, CGFloat.greatestFiniteMagnitude) : CGFloat.greatestFiniteMagnitude
        let constraintBox = CGSize(width: width, height: height)
        let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
        return rect.size
    }
    
}

extension UIFont {
    /// Helper function to apply font traits (e.g., bold, italic).
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
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
