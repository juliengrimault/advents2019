import Foundation

protocol Executable {
    var length: Int { get }

    func execute(memory: inout Memory, io: inout IO) -> ExecutionResult
}

struct ExecutionResult {
    var finished: Bool
    var jumpDestination: Address?

    static var `continue`: ExecutionResult {
        return ExecutionResult(finished: false, jumpDestination: nil)
    }

    static func jump(to address: Address) -> ExecutionResult {
        return ExecutionResult(finished: false, jumpDestination: address)
    }

    static var halt: ExecutionResult {
        return ExecutionResult(finished: true, jumpDestination: nil)
    }
}

extension Instruction: Executable {
    var length: Int {
        switch self {
        case let .add(add):
            return add.length + 1
        case let .mult(mult):
            return mult.length + 1
        case let .read(read):
            return read.length + 1
        case let .write(write):
            return write.length + 1
        case let .jump(jump):
            return jump.length + 1
        case let .comparison(comparison):
            return comparison.length + 1
        case .halt:
            return 1
        }
    }

    func execute(memory: inout Memory, io: inout IO) -> ExecutionResult {
        switch self {
        case let .add(add):
            return add.execute(memory: &memory, io: &io)
        case let .mult(mult):
            return mult.execute(memory: &memory, io: &io)
        case let .read(read):
            return read.execute(memory: &memory, io: &io)
        case let .write(write):
            return write.execute(memory: &memory, io: &io)
        case let .jump(jump):
            return jump.execute(memory: &memory, io: &io)
        case let .comparison(comparison):
            return comparison.execute(memory: &memory, io: &io)
        case .halt:
            return .halt
        }
    }
}

extension Add: Executable {
    var length: Int { 3 }

    func execute(memory: inout Memory, io: inout IO) -> ExecutionResult {
        let v1 = p1.value(memory: memory)
        let v2 = p2.value(memory: memory)
        memory[destination] = v1 + v2

        return .continue
    }
}

extension Mult: Executable {
    var length: Int { 3 }

    func execute(memory: inout Memory, io: inout IO) -> ExecutionResult {
        let v1 = p1.value(memory: memory)
        let v2 = p2.value(memory: memory)
        memory[destination] = v1 * v2

        return .continue
    }
}

extension Read: Executable {
    var length: Int { 1 }

    func execute(memory: inout Memory, io: inout IO) -> ExecutionResult {
        guard
            let value = io.input.read("Input value:") else {
                print("unable to get value from input :(")
                return .halt
        }

        memory[destination] = value

        return .continue
    }
}

extension Write: Executable {
    var length: Int { 1 }

    func execute(memory: inout Memory, io: inout IO) -> ExecutionResult {
        io.output.write(parameter.value(memory: memory))

        return .continue
    }
}

extension Jump: Executable {
    var length: Int { 2 }

    func execute(memory: inout Memory, io: inout IO) -> ExecutionResult {
        let value = predicate.value(memory: memory)
        let predicateResult = isInverted ? value == 0 : value != 0

        if predicateResult {
            let jumpDestination = destination.value(memory: memory)
            return .jump(to: jumpDestination)
        } else {
            return .continue
        }
    }
}

extension Comparison {
    var length: Int { 3 }

    func execute(memory: inout Memory, io: inout IO) -> ExecutionResult {
        let predicate = kind.predicate(memory: memory)

        let result = predicate(p1, p2) ? 1 : 0
        memory[destination] = result

        return .continue
    }
}

extension Comparison.Kind {
    func predicate(memory: Memory) -> (Parameter, Parameter) -> Bool {
        return { p1, p2 in
            let v1 = p1.value(memory: memory)
            let v2 = p2.value(memory: memory)

            switch self {
            case .lessThan:
                return v1 < v2
            case .equal:
                return v1 == v2
            }
        }
    }
}


