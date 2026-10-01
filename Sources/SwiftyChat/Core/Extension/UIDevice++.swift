//
//  UIDevice++.swift
//
//  Created by Enes Karaosman on 23.05.2020.
//  Copyright © 2020 All rights reserved.
//

#if canImport(UIKit)
import class UIKit.UIDevice
#endif

public struct Device {

    @MainActor public static var isLandscape: Bool {
        #if os(iOS)
        let orientation = UIDevice.current.orientation
        return orientation == .landscapeLeft || orientation == .landscapeRight

        #else
        return false
        #endif
    }
}
