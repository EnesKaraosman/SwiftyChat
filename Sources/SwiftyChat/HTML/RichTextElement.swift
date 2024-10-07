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

public class TextStyle: Codable {
    var bold: Bool = false
    var italic: Bool = false
    var underLine: Bool = false
    var strike: Bool = false
    var bullets: [RichTextElement]?
    var numbers: [RichTextElement]?
    
    public init(bold: Bool = false, italic: Bool = false, underLine: Bool = false,strike : Bool = false, bullets: [RichTextElement]? = nil, numbers: [RichTextElement]? = nil) {
        self.bold = bold
        self.italic = italic
        self.underLine = underLine
        self.bullets = bullets
        self.numbers = numbers
        self.strike = strike
    }
    func copy() -> TextStyle {
        let style = TextStyle()
        style.bold = self.bold
        style.italic = self.italic
        style.underLine = self.underLine
        style.bullets = self.bullets
        style.numbers = self.numbers
        style.strike = self.strike
        return style
    }
}
