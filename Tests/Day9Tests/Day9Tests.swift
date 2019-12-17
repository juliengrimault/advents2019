import XCTest
@testable import Day5

final class Day9Tests: XCTestCase {
    func testProgram1() throws {
        let code = Memory([109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99])
        assert(code: code, inputs: [], produce: [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99])
    }

    func testProgram2() {
        let code = Memory([1102,34915192,34915192,7,4,7,99,0])
        assert(code: code, inputs: [], produce: [1219070632396864])
    }

    func testProgram3() {
        let code = Memory([104,1125899906842624,99])
        assert(code: code, inputs: [], produce: [1125899906842624])
    }


    func assert(code: Memory, inputs: [Int], produce expected: [Int], file: StaticString = #file, line: UInt = #line) {
           var p = Program(memory: code)

           var outputs = [Int]()
           let io = valuesIO(input: inputs) {
               outputs.append($0)
           }

           p.run(io: io)

           XCTAssertEqual(outputs, expected, file: file, line: line)
       }
}
