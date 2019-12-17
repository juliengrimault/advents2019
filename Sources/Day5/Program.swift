import Foundation

typealias Address = Int

public struct Program {
    public var memory: Memory

    public init(memory: Memory) {
        self.memory = memory
    }


    public mutating func run(io: IO) {
        var instructionPointer = 0
        var baseAddress = 0

        while let instruction = Instruction(memory: memory, at: instructionPointer) {
            let result = instruction.execute(memory: &memory, base: &baseAddress, io: io)

            switch result {
            case .halt:
                return
            case let .jump(destination):
                instructionPointer = destination
            case .continue:
                instructionPointer += instruction.length
            }
        }
    }
}

