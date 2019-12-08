import XCTest
import Day5
@testable import Day7

final class Day7Tests: XCTestCase {

    func testProgram1() {
        let code = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
        assert(code: code, phases: [4,3,2,1,0], yields: 43210)
        XCTAssertEqual(maxOutput(for: code, numberOfAmplifier: 5), 43210)
    }

    func testProgram2() {
        let code = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
        assert(code: code, phases: [0,1,2,3,4], yields: 54321)
        XCTAssertEqual(maxOutput(for: code, numberOfAmplifier: 5), 54321)
    }

    func testProgram3() {
        let code = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
        assert(code: code, phases: [1,0,4,3,2], yields: 65210)
        XCTAssertEqual(maxOutput(for: code, numberOfAmplifier: 5), 65210)
    }

    func assert(code: Memory, phases: [Int], yields expected: Int, file: StaticString = #file, line: UInt = #line) {
        let result = output(for: code, phaseSettings: phases)
        XCTAssertEqual(result, expected, file: file, line: line)
    }
}
