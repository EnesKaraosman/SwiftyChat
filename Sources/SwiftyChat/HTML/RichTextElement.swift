//
//  HtmlElement.swift
//  htmlToAttributeText
//
//  Created by 1gz on 10/4/24.
//

public class RichTextElement: Codable {
    public var text: String?
    public var styles: TextStyle?
    public var newLine: Bool
    // Custom initializer
    public init(text: String? = nil, styles: TextStyle? = nil, newLine: Bool = false) {
        self.text = text
        self.styles = styles
        self.newLine = newLine
    }
    
    // Codable conformance for decoding
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        styles = try container.decodeIfPresent(TextStyle.self, forKey: .styles)
        newLine = try container.decodeIfPresent(Bool.self, forKey: .newLine) ?? false
    }
    
    // Codable conformance for encoding
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(styles, forKey: .styles)
        try container.encode(newLine, forKey: .newLine)
    }
    
    private enum CodingKeys: String, CodingKey {
        case text, styles, newLine
    }
}

public class ListItemStyle : Codable {
    var elements: [RichTextElement] = []
}

public class TextStyle: Codable {
    var bold: Bool = false
    var italic: Bool = false
    var underLine: Bool = false
    var strike: Bool = false
    var bullet : Bool = false
    var number : Bool = false
    var bulletStyles : [ListItemStyle] = []
    var numberStyles : [ListItemStyle] = []
    
    public init(bold: Bool = false, italic: Bool = false, underLine: Bool = false,strike : Bool = false, bullet: Bool = false, number: Bool = false) {
        self.bold = bold
        self.italic = italic
        self.underLine = underLine
        self.bullet = bullet
        self.number = number
        self.strike = strike
    }
    func addBulletStyle(item : ListItemStyle) {
        self.bulletStyles.append(item)
    }
    func addNumberStyle(item : ListItemStyle) {
        self.numberStyles.append(item)
    }
    func copy() -> TextStyle {
        let style = TextStyle()
        style.bold = self.bold
        style.italic = self.italic
        style.underLine = self.underLine
        style.bullet = self.bullet
        style.number = self.number
        style.strike = self.strike
        return style
    }
}
