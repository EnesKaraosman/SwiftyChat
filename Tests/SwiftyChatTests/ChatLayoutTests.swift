import CoreGraphics
import Testing
@testable import SwiftyChat

@Suite struct ChatLayoutTests {
    @Test func orientationFollowsViewportOnIOS() {
        #if os(iOS)
        #expect(CGSize(width: 900, height: 400).isChatLandscape)
        #expect(!CGSize(width: 400, height: 900).isChatLandscape)
        #else
        #expect(!CGSize(width: 900, height: 400).isChatLandscape)
        #endif
    }
}
