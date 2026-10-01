import CoreGraphics

extension CGSize {
    public var isChatLandscape: Bool {
        #if os(iOS)
        width > height
        #else
        false
        #endif
    }
}
