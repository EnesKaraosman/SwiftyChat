//
//  OrientationInfo.swift
//  
//
//  Created by Enes Karaosman on 6.08.2020.
//

import Foundation
import class UIKit.UIDevice
import SwiftUI

final class OrientationInfo: ObservableObject {
    enum Orientation {
        case portrait
        case landscape
    }
    
    @Published var orientation: Orientation
    
    private var _observer: NSObjectProtocol?
    
    init() {
        // fairly arbitrary starting value for 'flat' orientations
        if UIDevice.current.orientation.isLandscape {
            orientation = .landscape
        }
        else {
            orientation = .portrait
        }
        
        // unowned self because we unregister before self becomes invalid
        _observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [unowned self] note in
            guard let device = note.object as? UIDevice else {
                return
            }
            if device.orientation.isPortrait {
                orientation = .portrait
            }
            else if device.orientation.isLandscape {
                orientation = .landscape
            }
        }
    }
    
    deinit {
        if let observer = _observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

struct DeviceOrientationBasedView<Content: View>: View {
    
    public var portrait: Content
    public var landscape: Content
    
    @EnvironmentObject var model: OrientationInfo
    
    /// Portrait & Landscape orientation closures to represent when the related DeviceOrientation is active
    /// - Parameters:
    ///   - portrait: `View` that is represented in `Portrait` mode
    ///   - landscape: `View` that is represented in `Landscape` mode
    public init(
        @ViewBuilder portrait: () -> Content,
        @ViewBuilder landscape: () -> Content
    ) {
        self.portrait = portrait()
        self.landscape = landscape()
    }
    
    @ViewBuilder var body: some View {
        if model.orientation == .portrait {
            portrait
        } else {
            landscape
        }
    }
}
