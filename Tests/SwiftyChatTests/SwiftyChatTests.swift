import XCTest
@testable import SwiftyChat

final class SwiftyChatTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftyChat().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
