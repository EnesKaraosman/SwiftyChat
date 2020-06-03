//
//  UIEdgeInsets.swift
//  
//
//  Created by Enes Karaosman on 3.06.2020.
//

import UIKit

internal extension UIEdgeInsets {

    var vertical: CGFloat {
        return top + bottom
    }

    var horizontal: CGFloat {
        return left + right
    }

}
