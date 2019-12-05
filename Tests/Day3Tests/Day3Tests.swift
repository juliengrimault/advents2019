import XCTest
@testable import Day3

final class Day3Tests: XCTestCase {
    func testFixture1() {
        assertWires(distance: 6, string: """
R8,U5,L5,D3
U7,R6,D4,L4
""")

        assertWires(distance: 159, string: """
R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83
""")

        assertWires(distance: 135, string: """
R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
""")

    }

        func testTime() {
            assertWires(time: 30, string: """
R8,U5,L5,D3
U7,R6,D4,L4
""")

            assertWires(time: 610, string: """
R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83
""")

            assertWires(time: 410, string: """
R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
""")
        }

    func assertWires(distance: Int, string: String , file: StaticString = #file, line: UInt = #line) {
        guard let board = Board.makeFromInput(string) else {
              XCTFail()
            return
          }

        XCTAssertEqual(board.closestIntersectionDistance, distance, file: file, line: line)
    }

    func assertWires(time: Int, string: String , file: StaticString = #file, line: UInt = #line) {
           guard let board = Board.makeFromInput(string) else {
                 XCTFail()
               return
             }

           XCTAssertEqual(board.fastestIntersection, time, file: file, line: line)
       }
}
