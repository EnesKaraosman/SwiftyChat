//
//  UIFont+Extension.swift
//  
//
//  Created by Enes Karaosman on 27.07.2020.
//

import SwiftUI

public extension Font.Weight {
    
    init(_ weight: UIFont.Weight) {
        switch weight {
        case .ultraLight: self = .ultraLight
        case .thin:       self = .thin
        case .light:      self = .light
        case .regular:    self = .regular
        case .medium:     self = .medium
        case .semibold:   self = .semibold
        case .bold:       self = .bold
        case .heavy:      self = .heavy
        case .black:      self = .black
        default:          self = .regular
        }
    }
    
}
