//
//  CommonLabelStyle.swift
//  
//
//  Created by Enes Karaosman on 11.08.2020.
//

import SwiftUI

public struct CommonLabelStyle {
    
    public let font: Font
    public let textColor: Color
    public let fontWeight: Font.Weight
    
    public init(
        font: Font = .body,
        textColor: Color = .primary,
        fontWeight: Font.Weight = .regular
    ) {
        self.font = font
        self.textColor = textColor
        self.fontWeight = fontWeight
    }
    
}
