//
//  AttributedTextStyle.swift
//  
//
//  Created by Enes Karaosman on 13.08.2020.
//

import UIKit

public struct AttributedTextStyle {
 
    public let tintColor: UIColor
    public let textColor: UIColor
    public let font: UIFont
    public let fontWeight: UIFont.Weight
    public let enabledDetectors: [DetectorType]
    
    public init(
        tintColor: UIColor = .blue,
        textColor: UIColor = .white,
        font: UIFont = .monospacedSystemFont(ofSize: 17, weight: .semibold),
        fontWeight: UIFont.Weight = .semibold,
        enabledDetectors: [DetectorType] = []
    ) {
        self.tintColor = tintColor
        self.textColor = textColor
        self.font = font
        self.fontWeight = fontWeight
        self.enabledDetectors = enabledDetectors
    }
}
