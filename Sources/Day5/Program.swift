import Foundation

public typealias Memory = [Int]

typealias Address = Int

public struct Program {
    public var memory: Memory
    public var io: IO

    public init(memory: Memory, io: IO = .interractive) {
        self.memory = memory
        self.io = io
    }


    public mutating func run() {
        var instructionPointer = 0

        while let instruction = Instruction(memory: memory, at: instructionPointer) {
            let result = instruction.execute(memory: &memory, io: &io)
            if result.finished {
                return
            }

            if let destination = result.jumpDestination {
                instructionPointer = destination
            } else {
                instructionPointer += instruction.length
            }
        }
    }
}

