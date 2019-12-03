import XCTest
@testable import advents2019

final class advents2019Tests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(advents2019().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
