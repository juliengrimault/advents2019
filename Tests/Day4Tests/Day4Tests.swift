import XCTest
@testable import Day4

final class Day4Tests: XCTestCase {
    func testDigits() {
        XCTAssertEqual(111_111.digits(), [1,1,1,1,1,1])
        XCTAssertEqual(223450.digits(), [2,2,3,4,5,0])
        XCTAssertEqual(123789.digits(), [1,2,3,7,8,9])
    }

    func testValidity() {
        XCTAssertTrue(isValid(111111))
        XCTAssertFalse(isValid(223450))
        XCTAssertFalse(isValid(123789))
    }

    func testValidity2() {
        XCTAssertTrue(isValid2(112233))
        XCTAssertFalse(isValid2(123444))
        XCTAssertTrue(isValid2(111122))
        XCTAssertFalse(isValid2(111222))
    }
}
