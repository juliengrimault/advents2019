import Foundation

public struct ProgramSolver {
    public var program: LegacyProgram
    public var inputs: (Range<Int>, Range<Int>)

    public init(program: LegacyProgram, inputs: (Range<Int>, Range<Int>) =  (0..<100, 0..<100)) {
        self.program = program
        self.inputs = inputs
    }

    public func solve(for expected: Int) throws -> (Int, Int)? {
        for i1 in inputs.0 {
            for i2 in inputs.1 {
                var p = try program.seeded((i1, i2))
                try p.run()
                if p.output == expected {
                    return (i1, i2)
                }
            }
        }
        return nil
    }
}
