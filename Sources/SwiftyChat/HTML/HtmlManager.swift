//
//  HtmlManager.swift
//  htmlToAttributeText
//
//  Created by 1gz on 10/4/24.
//

import ObjectiveC
import Foundation
import UIKit
import SwiftUI

public class HtmlManager : NSObject {
    static let shared = HtmlManager()
    
    public override init() {
        super.init()
        
    }
    func uiFontWeight(from fontWeight: Font.Weight) -> UIFont.Weight {
        switch fontWeight {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        default: return .regular
        }
    }

    @available(iOS 15, *)
    public func createAttributeText(from html: String, defaultStyle: CommonTextStyle) -> AttributedString {
        let elements = richTextElementFromHtml(html: html)
        var attributedString = AttributedString()

        // Define the base UIFont using the default font and font weight
        let baseUIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: self.uiFontWeight(from: defaultStyle.fontWeight))

        for element in elements {
            if element.newLine {
                attributedString.append(AttributedString("\n"))
            } else if let text = element.text {
                var substring = AttributedString(text)
                var uiFont = baseUIFont

                if let styles = element.styles {
                    // Create a UIFont with the desired traits
                    uiFont = fontWithTraits(baseFont: baseUIFont, bold: styles.bold, italic: styles.italic)
                }
                // Apply the font to the substring
                substring.font = Font(uiFont)

                // Apply underline if needed
                if let styles = element.styles, styles.underLine {
                    substring.underlineStyle = .single
                }

                // Apply default text color
                substring.foregroundColor = defaultStyle.textColor

                attributedString.append(substring)
            }
        }
        return attributedString
    }
    // Helper function to create UIFont with desired traits
    func fontWithTraits(baseFont: UIFont, bold: Bool, italic: Bool) -> UIFont {
        var symbolicTraits = baseFont.fontDescriptor.symbolicTraits
        
        if bold {
            symbolicTraits.insert(.traitBold)
        }
        if italic {
            symbolicTraits.insert(.traitItalic)
        }
        
        if let descriptor = baseFont.fontDescriptor.withSymbolicTraits(symbolicTraits) {
            return UIFont(descriptor: descriptor, size: baseFont.pointSize)
        } else {
            return baseFont
        }
    }
    
    public func richTextElementFromHtml(html: String) -> [RichTextElement] {
        var elements: [RichTextElement] = []
        
        // Updated regular expression to capture tags and text
        let tagRegex = try! NSRegularExpression(pattern: "(<[^>]+>|[^<]+)", options: [])
        let matches = tagRegex.matches(in: html, options: [], range: NSRange(html.startIndex..., in: html))
        
        var styleStack: [TextStyle] = [TextStyle()] // Initialize the style stack with a default style
        
        for match in matches {
            let matchRange = match.range(at: 0)
            guard let range = Range(matchRange, in: html) else { continue }
            let fragment = String(html[range])
            
            if fragment.hasPrefix("<") {
                // It's a tag
                let tagContent = fragment.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).lowercased()
                let isClosingTag = tagContent.hasPrefix("/")
                let tag = isClosingTag ? String(tagContent.dropFirst()) : tagContent
                
                switch tag {
                case "b", "strong", "i", "em", "u", "ins", "li", "ol":
                    if isClosingTag {
                        // Pop the style from the stack
                        if styleStack.count > 1 {
                            styleStack.removeLast()
                        }
                    } else {
                        // Push a new style onto the stack
                        let newStyle = styleStack.last!.copy()
                        switch tag {
                        case "b", "strong":
                            newStyle.bold = true
                        case "i", "em":
                            newStyle.italic = true
                        case "u", "ins":
                            newStyle.underLine = true
                        case "li":
                            newStyle.bullet = true
                        case "ol":
                            newStyle.number = true
                        default:
                            break
                        }
                        styleStack.append(newStyle)
                    }
                case "br":
                    elements.append(RichTextElement(newLine: true))
                default:
                    break
                }
            } else {
                // It's text content, possibly containing newlines
                let texts = fragment.components(separatedBy: "\n")
                for (index, text) in texts.enumerated() {
                    let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmedText.isEmpty {
                        let currentStyle = styleStack.last!
                        let element = RichTextElement(text: trimmedText, styles: currentStyle.copy())
                        elements.append(element)
                    }
                    if index < texts.count - 1 {
                        // Newline detected within text
                        elements.append(RichTextElement(newLine: true))
                    }
                }
            }
        }
        return elements
    }
    
    
    
    
    
}
