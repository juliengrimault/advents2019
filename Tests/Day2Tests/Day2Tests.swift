import XCTest
@testable import Day2

final class Day2Tests: XCTestCase {
    func testExample1() throws {
        let p1 = LegacyProgram(codes: [1,0,0,0,99])
        let result = try p1.afterRunning()
        XCTAssertEqual(result.codes, [2,0,0,0,99])
    }

    func testExample2() throws {
        let p1 = LegacyProgram(codes: [2,3,0,3,99])
        let result = try p1.afterRunning()
        XCTAssertEqual(result.codes, [2,3,0,6,99])
    }

    func testExample3() throws {
        let p1 = LegacyProgram(codes: [2,4,4,5,99,0])
        let result = try p1.afterRunning()
        XCTAssertEqual(result.codes, [2,4,4,5,99,9801])
    }

    func testExample4() throws {
        let p1 = LegacyProgram(codes: [1,1,1,4,99,5,6,0,99])
        let result = try p1.afterRunning()
        XCTAssertEqual(result.codes, [30,1,1,4,2,5,6,0,99])
    }
}
