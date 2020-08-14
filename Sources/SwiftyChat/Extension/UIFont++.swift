//
//  UIFont+Extension.swift
//  
//
//  Created by Enes Karaosman on 27.07.2020.
//

import SwiftUI

internal extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let newDescriptor = fontDescriptor.addingAttributes([.traits: [
            UIFontDescriptor.TraitKey.weight: weight]
        ])
        return UIFont(descriptor: newDescriptor, size: pointSize)
    }
}
