import XCTest
@testable import Day5

final class Day5Tests: XCTestCase {

    let memory = [1002,4,3,4]

    func testParameterModeParsing() {
        let modes = ParameterModes(instruction: 1002)
        XCTAssertEqual(modes.modes.count, 2)
        XCTAssertEqual(modes.modes[0], .position)
        XCTAssertEqual(modes.modes[1], .immediate)
    }

    func testInstructionParsing() {
        let instruction = Instruction(memory: memory, at: 0)
        XCTAssertEqual(
            instruction,
            .mult(Mult(
                p1: .position(4),
                p2: .immediate(3),
                destination: 4
            ))
        )
    }

    func testP1() {
        let code = [3,9,8,9,10,9,4,9,99,-1,8]
        assert(code: code, inputs: 7, produce: [0])
        assert(code: code, inputs: 8, produce: [1])
        assert(code: code, inputs: 9, produce: [0])
    }

    func testP2() {
        let code = [3,9,7,9,10,9,4,9,99,-1,8]
        assert(code: code, inputs: 7, produce: [1])
        assert(code: code, inputs: 8, produce: [0])
        assert(code: code, inputs: 9, produce: [0])
    }

    func testP3() {
        let code = [3,3,1108,-1,8,3,4,3,99]
        assert(code: code, inputs: 7, produce: [0])
        assert(code: code, inputs: 8, produce: [1])
        assert(code: code, inputs: 9, produce: [0])
    }

    func testP4() {
        let code = [3,3,1107,-1,8,3,4,3,99]
        assert(code: code, inputs: 7, produce: [1])
        assert(code: code, inputs: 8, produce: [0])
        assert(code: code, inputs: 9, produce: [0])
    }

    func testP5() {
        let code = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]
        assert(code: code, inputs: 0, produce: [0])
        assert(code: code, inputs: 8, produce: [1])
        assert(code: code, inputs: 9, produce: [1])
    }

    func testP6() {
        let code = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1]
        assert(code: code, inputs: 0, produce: [0])
        assert(code: code, inputs: 8, produce: [1])
        assert(code: code, inputs: 9, produce: [1])
    }

    func testP7() {
        let code = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
        1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
        999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
        assert(code: code, inputs: 0, produce: [999])
        assert(code: code, inputs: 8, produce: [1000])
        assert(code: code, inputs: 9, produce: [1001])
    }

    func assert(code: Memory, inputs: Int..., produce expected: [Int], file: StaticString = #file, line: UInt = #line) {
        var p = Program(memory: code, io: .values(input: inputs, output: StoreOutput()))
        p.run()
        let outputs = (p.io.output as! StoreOutput).values
        XCTAssertEqual(outputs, expected, file: file, line: line)
    }
}

//Optional(Day5.Instruction.mult(Day5.Mult(p1: Day5.Parameter.position(4), p2: Day5.Parameter.position(3), address: 4)))
//Optional(Day5.Instruction.mult(Day5.Mult(p1: Day5.Parameter.position(33), p2: Day5.Parameter.immediate(3), address: 4))
