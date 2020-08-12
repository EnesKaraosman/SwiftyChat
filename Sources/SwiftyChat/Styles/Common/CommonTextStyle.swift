//
//  CommonTextStyle.swift
//  
//
//  Created by Enes Karaosman on 11.08.2020.
//

import SwiftUI

public struct CommonTextStyle {
    
    public let textColor: Color
    public let font: Font
    public let fontWeight: Font.Weight
    
    public init(
        textColor: Color = .primary,
        font: Font = .body,
        fontWeight: Font.Weight = .regular
    ) {
        self.textColor = textColor
        self.font = font
        self.fontWeight = fontWeight
    }
    
}
