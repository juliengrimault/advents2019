import Foundation

public struct Program {
    public var codes: [Int]

    public init(codes: [Int]) {
        self.codes = codes
    }
}

enum OpCode: Int {
    case add = 1
    case mult = 2
    case halt = 99
}

extension Program {
    public func afterRunning() throws -> Program {
        var copy = self
        try copy.run()
        return copy
    }

    public mutating func run() throws{
        var idx = codes.startIndex

        while true {
            let code = try opCode(at: idx)
            switch code {
            case .add:
                try operation(opCodeIndex: idx, function: +)
                idx += 4

            case .mult:
                try operation(opCodeIndex: idx, function: *)
                idx += 4

            case .halt:
                return
            }
        }
    }

    private mutating func operation(opCodeIndex: Int, function: (Int, Int) -> Int) throws {
        let readIndex1 = try value(at: opCodeIndex + 1)
        let readIndex2 = try value(at: opCodeIndex + 2)

        let op1 = try value(at: readIndex1)
        let op2 = try value(at: readIndex2)
        let result = function(op1, op2)

        let writeIndex = try value(at: opCodeIndex + 3)
        try setValue(value: result, at: writeIndex)
    }

    private func opCode(at index: Int) throws -> OpCode {
        let v = try value(at: index)

        guard let code = OpCode(rawValue: v) else {
            throw Program.Error.unknownOpCode(v)
        }

        return code
    }
}

extension Program {
    public func value(at index: Int) throws -> Int {
        guard index >= codes.startIndex && index < codes.endIndex else {
            throw Program.Error.outOfBound(index)
        }
        return codes[index]
    }

    public mutating func setValue(value: Int, at index: Int) throws {
        guard index >= codes.startIndex && index < codes.endIndex else {
            throw Program.Error.outOfBound(index)
        }
        codes[index] = value
    }
}


extension Program {
    public enum Error: Swift.Error {
        case outOfBound(Int)
        case unknownOpCode(Int)
    }
}

extension Program {
    public mutating func seed(_ input: (Int, Int)) throws {
        try setValue(value: input.0, at: 1)
        try setValue(value: input.1, at: 2)
    }

    public func seeded(_ input: (Int, Int)) throws -> Program {
        var copy = self
        try copy.seed(input)
        return copy
    }
}

extension Program {
    public func restoredTo1202ProgramAlarm() throws -> Program {
        return try seeded((12, 2))
    }
}

extension Program {
    public var output: Int {
        return codes[0]
    }
}
