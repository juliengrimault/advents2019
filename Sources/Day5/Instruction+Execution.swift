import Foundation

protocol Executable {
    var length: Int { get }

    func execute(memory: inout Memory, base: inout Address, io: IO) -> ExecutionResult
}

enum ExecutionResult {
    case halt
    case jump(Address)
    case `continue`
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
        case let .adjustBase(adjust):
            return adjust.length + 1
        case .halt:
            return 1
        }
    }

    func execute(memory: inout Memory, base: inout Address, io: IO) -> ExecutionResult {
        switch self {
        case let .add(add):
            return add.execute(memory: &memory, base: &base, io: io)
        case let .mult(mult):
            return mult.execute(memory: &memory, base: &base, io: io)
        case let .read(read):
            return read.execute(memory: &memory, base: &base, io: io)
        case let .write(write):
            return write.execute(memory: &memory, base: &base, io: io)
        case let .jump(jump):
            return jump.execute(memory: &memory, base: &base, io: io)
        case let .comparison(comparison):
            return comparison.execute(memory: &memory, base: &base, io: io)
        case let .adjustBase(adjust):
            return adjust.execute(memory: &memory, base: &base, io: io)
        case .halt:
            return .halt
        }
    }
}

extension Add: Executable {
    var length: Int { 3 }

    func execute(memory: inout Memory, base: inout Address, io: IO) -> ExecutionResult {
        let v1 = p1.value(memory: memory, base: base)
        let v2 = p2.value(memory: memory, base: base)
        let dstAddress = destination.address(base: base)!
        memory[dstAddress] = v1 + v2

        return .continue
    }
}

extension Mult: Executable {
    var length: Int { 3 }

    func execute(memory: inout Memory, base: inout Address, io: IO) -> ExecutionResult {
        let v1 = p1.value(memory: memory, base: base)
        let v2 = p2.value(memory: memory, base: base)
        let dstAddress = destination.address(base: base)!
        memory[dstAddress] = v1 * v2

        return .continue
    }
}

extension Read: Executable {
    var length: Int { 1 }

    func execute(memory: inout Memory, base: inout Address, io: IO) -> ExecutionResult {
        let dstAddress = destination.address(base: base)!
        memory[dstAddress] = io.input()

        return .continue
    }
}

extension Write: Executable {
    var length: Int { 1 }

    func execute(memory: inout Memory, base: inout Address, io: IO) -> ExecutionResult {
        io.output(parameter.value(memory: memory, base: base))
        
        return .continue
    }
}

extension Jump: Executable {
    var length: Int { 2 }

    func execute(memory: inout Memory, base: inout Address, io: IO) -> ExecutionResult {
        let value = predicate.value(memory: memory, base: base)
        let predicateResult = isInverted ? value == 0 : value != 0

        if predicateResult {
            let jumpDestination = destination.value(memory: memory, base: base)
            return .jump(jumpDestination)
        } else {
            return .continue
        }
    }
}

extension Comparison {
    var length: Int { 3 }

    func execute(memory: inout Memory, base: inout Address, io: IO) -> ExecutionResult {
        let predicate = kind.predicate(memory: memory, base: base)

        let result = predicate(p1, p2) ? 1 : 0
        let dstAddress = destination.address(base: base)!
        memory[dstAddress] = result

        return .continue
    }
}

extension Comparison.Kind {
    func predicate(memory: Memory, base: Address) -> (Parameter, Parameter) -> Bool {
        return { p1, p2 in
            let v1 = p1.value(memory: memory, base: base)
            let v2 = p2.value(memory: memory, base: base)

            switch self {
            case .lessThan:
                return v1 < v2
            case .equal:
                return v1 == v2
            }
        }
    }
}

extension AdjustBase: Executable {
    var length: Int { 1 }

    func execute(memory: inout Memory, base: inout Address, io: IO) -> ExecutionResult {
        let value = adjustement.value(memory: memory, base: base)
        base += value
        return .continue
    }
}
