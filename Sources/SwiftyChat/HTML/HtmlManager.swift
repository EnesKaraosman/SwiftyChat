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
                // Handle regular text
                var substring = AttributedString(text)
                var uiFont = baseUIFont

                if let styles = element.styles {
                    // Create a UIFont with the desired traits
                    uiFont = fontWithTraits(baseFont: baseUIFont, bold: styles.bold, italic: styles.italic)
                    // Underline and strike-through
                    if styles.underLine {
                        substring.underlineStyle = .single
                    }
                    if styles.strike {
                        substring.strikethroughStyle = .single
                    }
                }
                // Apply the font to the substring
                substring.font = Font(uiFont)
                // Apply default text color
                substring.foregroundColor = defaultStyle.textColor

                attributedString.append(substring)
            } else if let styles = element.styles {
                // Handle lists
                if styles.bullet {
                    // Handle bullet list
                    for listItem in styles.bulletStyles {
                        var itemAttributedString = AttributedString()
                        // Process each element within the list item
                        for itemElement in listItem.elements {
                            if itemElement.newLine {
                                itemAttributedString.append(AttributedString("\n"))
                            } else if let itemText = itemElement.text {
                                var itemSubstring = AttributedString(itemText)
                                var uiFont = baseUIFont

                                if let itemStyles = itemElement.styles {
                                    // Apply styles from itemElement
                                    uiFont = fontWithTraits(baseFont: baseUIFont, bold: itemStyles.bold, italic: itemStyles.italic)
                                    // Underline and strike-through
                                    if itemStyles.underLine {
                                        itemSubstring.underlineStyle = .single
                                    }
                                    if itemStyles.strike {
                                        itemSubstring.strikethroughStyle = .single
                                    }
                                }
                                // Apply the font to the substring
                                itemSubstring.font = Font(uiFont)
                                // Apply default text color
                                itemSubstring.foregroundColor = defaultStyle.textColor

                                itemAttributedString.append(itemSubstring)
                            }
                        }
                        // Prepend bullet character
                        let bulletText = "\u{2022} "
                        var bulletString = AttributedString(bulletText)
                        bulletString.font = Font(baseUIFont)
                        bulletString.foregroundColor = defaultStyle.textColor
                        // Combine bullet and item text
                        bulletString.append(itemAttributedString)
                        attributedString.append(bulletString)
                        attributedString.append(AttributedString("\n")) // Add newline after each list item
                    }
                } else if styles.number {
                    // Handle numbered list
                    for (index, listItem) in styles.numberStyles.enumerated() {
                        var itemAttributedString = AttributedString()
                        // Process each element within the list item
                        for itemElement in listItem.elements {
                            if itemElement.newLine {
                                itemAttributedString.append(AttributedString("\n"))
                            } else if let itemText = itemElement.text {
                                var itemSubstring = AttributedString(itemText)
                                var uiFont = baseUIFont

                                if let itemStyles = itemElement.styles {
                                    // Apply styles from itemElement
                                    uiFont = fontWithTraits(baseFont: baseUIFont, bold: itemStyles.bold, italic: itemStyles.italic)
                                    // Underline and strike-through
                                    if itemStyles.underLine {
                                        itemSubstring.underlineStyle = .single
                                    }
                                    if itemStyles.strike {
                                        itemSubstring.strikethroughStyle = .single
                                    }
                                }
                                // Apply the font to the substring
                                itemSubstring.font = Font(uiFont)
                                // Apply default text color
                                itemSubstring.foregroundColor = defaultStyle.textColor

                                itemAttributedString.append(itemSubstring)
                            }
                        }
                        // Prepend number and period
                        let numberText = "\(index + 1). "
                        var numberString = AttributedString(numberText)
                        numberString.font = Font(baseUIFont)
                        numberString.foregroundColor = defaultStyle.textColor
                        // Combine number and item text
                        numberString.append(itemAttributedString)
                        attributedString.append(numberString)
                        attributedString.append(AttributedString("\n")) // Add newline after each list item
                    }
                }
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
        let tagRegex = try! NSRegularExpression(pattern: "(<[^>]+>|[^<]+)", options: [])
        let matches = tagRegex.matches(in: html, options: [], range: NSRange(html.startIndex..., in: html))
        
        var styleStack: [TextStyle] = [TextStyle()] // Main style stack
        var isInListItem = false
        var currentListType: String? = nil // "ul" or "ol"
        var listItemStyleStack: [TextStyle] = [] // Style stack for list items
        var listItems: [ListItemStyle] = [] // Accumulated list items
        var listItemElements: [RichTextElement] = [] // Elements within a list item
        
        for match in matches {
            let matchRange = match.range(at: 0)
            guard let range = Range(matchRange, in: html) else { continue }
            let fragment = String(html[range])
            
            if fragment.hasPrefix("<") {
                // It's a tag
                let tagContent = fragment.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).lowercased()
                let isClosingTag = tagContent.hasPrefix("/")
                let tag = isClosingTag ? String(tagContent.dropFirst()) : tagContent
                
                if isClosingTag {
                    // Handling closing tags
                    switch tag {
                    case "li":
                        // End of list item
                        let listItemStyle = ListItemStyle()
                        listItemStyle.elements = listItemElements
                        listItems.append(listItemStyle)
                        listItemElements = []
                        listItemStyleStack = []
                        isInListItem = false
                    case "ul", "ol":
                        // End of list
                        currentListType = nil
                        let listStyle = TextStyle()
                        if tag == "ul" {
                            listStyle.bullet = true
                            listStyle.bulletStyles = listItems
                        } else if tag == "ol" {
                            listStyle.number = true
                            listStyle.numberStyles = listItems
                        }
                        elements.append(RichTextElement(text: nil, styles: listStyle, newLine: false))
                        listItems = []
                    default:
                        // Pop the appropriate style stack
                        if isInListItem && listItemStyleStack.count > 0 {
                            listItemStyleStack.removeLast()
                        } else if styleStack.count > 1 {
                            styleStack.removeLast()
                        }
                    }
                } else {
                    // Handling opening tags
                    var newStyle: TextStyle
                    if isInListItem {
                        newStyle = (listItemStyleStack.last ?? TextStyle()).copy()
                    } else {
                        newStyle = (styleStack.last ?? TextStyle()).copy()
                    }
                    
                    switch tag {
                    case "b", "strong":
                        newStyle.bold = true
                    case "i", "em":
                        newStyle.italic = true
                    case "u", "ins":
                        newStyle.underLine = true
                    case "ul":
                        currentListType = "ul"
                    case "ol":
                        currentListType = "ol"
                    case "li":
                        isInListItem = true
                        listItemStyleStack = [newStyle]
                    case "s", "del":
                        newStyle.strike = true
                    default:
                        break
                    }
                    
                    // Push the new style onto the appropriate stack
                    if tag != "li" {
                        if isInListItem {
                            listItemStyleStack.append(newStyle)
                        } else {
                            styleStack.append(newStyle)
                        }
                    }
                }
            } else {
                // It's text content
                if isInListItem {
                    // Collect styled text fragments within the list item
                    let texts = fragment.components(separatedBy: "\n")
                    for (index, text) in texts.enumerated() {
                        if !text.isEmpty {
                            let currentStyle = listItemStyleStack.last ?? TextStyle()
                            let element = RichTextElement(text: text, styles: currentStyle.copy())
                            listItemElements.append(element)
                        }
                        if index < texts.count - 1 {
                            // Newline detected within text
                            listItemElements.append(RichTextElement(newLine: true))
                        }
                    }
                } else {
                    // Process text outside list items
                    let texts = fragment.components(separatedBy: "\n")
                    for (index, text) in texts.enumerated() {
                        if !text.isEmpty {
                            let currentStyle = styleStack.last!
                            let element = RichTextElement(text: text, styles: currentStyle.copy())
                            elements.append(element)
                        }
                        if index < texts.count - 1 {
                            elements.append(RichTextElement(newLine: true))
                        }
                    }
                }
            }
        }
        return elements
    }
    
    
    
    
    
}
