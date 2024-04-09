//
//  UIEdgeInsets.swift
//  
//
//  Created by Enes Karaosman on 3.06.2020.
//

#if canImport(UIKit)
import UIKit
#endif

internal extension UIEdgeInsets {
    
    var vertical: CGFloat {
        top + bottom
    }
    
    var horizontal: CGFloat {
        left + right
    }
}
