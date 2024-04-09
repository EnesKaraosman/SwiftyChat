//
//  TextFrameCalculator.swift
//  
//
//  Created by Enes Karaosman on 30.09.2020.
//

#if canImport(UIKit)
import UIKit
#endif

// https://gist.github.com/azimin/aa1a79aefa1cec031152fa63401d2292
internal final class AZTextFrameAttributes: NSObject {
    
    // MARK: - Properties
    
    fileprivate(set) var width: CGFloat = 0
    fileprivate(set) var string: String?
    fileprivate(set) var attributedString: NSAttributedString?
    
    // MARK: - Attributes
    
    var attributes: [NSAttributedString.Key: Any] = [:]
    var lineBreakingMode: NSLineBreakMode = NSLineBreakMode.byWordWrapping {
        didSet {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineBreakMode = lineBreakingMode
            attributes[NSAttributedString.Key.paragraphStyle] = paragraph
        }
    }
    
    // MARK: - Init
    
    init(string: String, font: UIFont) {
        self.string = string
        self.attributes = [NSAttributedString.Key.font: font]
    }
    
    init(string: String, width: CGFloat, font: UIFont) {
        self.string = string
        self.width = width
        self.attributes = [NSAttributedString.Key.font: font]
    }
    
    init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }
    
    init(attributedString: NSAttributedString, width: CGFloat) {
        self.attributedString = attributedString
        self.width = width
    }
    
    // MARK: - Calculation
    
    func calculatedTextWidth() -> CGFloat {
        return AZTextFrame(attributes: self).width
    }
    
    func calculatedTextHeight() -> CGFloat {
        return AZTextFrame(attributes: self).height
    }
}

internal final class AZTextFrame: NSObject {
    
    // MARK: - Properties
    
    let attributes: AZTextFrameAttributes
    fileprivate(set) var width: CGFloat = 0
    fileprivate(set) var height: CGFloat = 0
    
    // MARK: - Init
    
    init(attributes: AZTextFrameAttributes) {
        self.attributes = attributes
        super.init()
        self.calculate()
    }
    
    private func calculate() {
        let sizeForHeight = CGSize(width: attributes.width, height: CGFloat.greatestFiniteMagnitude / 2)
        let sizeForWidth = CGSize(width: CGFloat.greatestFiniteMagnitude / 2, height: CGFloat.greatestFiniteMagnitude / 2)
        
        if let string = attributes.string {
            height = (string as NSString).boundingRect(
                with: sizeForHeight,
                options: .usesLineFragmentOrigin,
                attributes: attributes.attributes,
                context: nil
            ).height
            width = (string as NSString).boundingRect(with: sizeForWidth, options: .usesLineFragmentOrigin, attributes: attributes.attributes, context: nil).width
        } else if let attributedString = attributes.attributedString {
            height = attributedString.boundingRect(with: sizeForHeight, options: .usesLineFragmentOrigin, context: nil).height
            width = attributedString.boundingRect(with: sizeForWidth, options: .usesLineFragmentOrigin, context: nil).width
        }
        
        height = roundTillHalf(value: height)
        width = roundTillHalf(value: width)
    }
    
    private func roundTillHalf(value: CGFloat) -> CGFloat {
        if value - CGFloat(Int(value)) >= 0.5 {
            return CGFloat(Int(value)) + 1
        } else {
            return CGFloat(Int(value)) + 0.5
        }
    }
}
