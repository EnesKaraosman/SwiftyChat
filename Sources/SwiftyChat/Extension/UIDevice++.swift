//
//  UIDevice++.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 23.05.2020.
//  Copyright © 2020 All rights reserved.
//

import UIKit

public extension UIDevice {
    
    static var isLandscape: Bool {
        return UIDevice.current.orientation == .landscapeLeft ||
            UIDevice.current.orientation == .landscapeRight
    }
    
    static var isPortrait: Bool {
        return UIDevice.current.orientation == .portrait ||
            UIDevice.current.orientation == .portraitUpsideDown
    }
    
}
