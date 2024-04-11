//
//  UIDevice++.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 23.05.2020.
//  Copyright © 2020 All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif

public struct Device {

    public static var isLandscape: Bool {
        #if os(iOS)
        return UIDevice.current.orientation == .landscapeLeft ||
        UIDevice.current.orientation == .landscapeRight

        #endif

        #if os(macOS)
        return false
        #endif
    }
}
