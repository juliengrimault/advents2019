import Foundation


extension Instruction {
    init?(memory: Memory, at address: Address) {
        let value = memory[address]

        let instructionCode = value % 100

        switch instructionCode {
        case 1:
            self = .add(Add(memory: memory, instructionAddress: address))
        case 2:
            self = .mult(Mult(memory: memory, instructionAddress: address))
        case 3:
            self = .read(Read(memory: memory, instructionAddress: address))
        case 4:
            self = .write(Write(memory: memory, instructionAddress: address))
        case 5:
            let jumpIfTrue = Jump.isInverted(false)
            self = .jump(jumpIfTrue(memory, address))
        case 6:
            let jumpIfFalse = Jump.isInverted(true)
            self = .jump(jumpIfFalse(memory, address))
        case 7:
            let lessThan = Comparison.kind(.lessThan)
            self = .comparison(lessThan(memory, address))
        case 8:
            let equal = Comparison.kind(.equal)
            self = .comparison(equal(memory, address))
        case 9:
            self = .adjustBase(AdjustBase(memory: memory, instructionAddress: address))
        case 99:
            self = .halt
        default:
            print("Unable to build instruction from value: \(value)")
            return nil
        }
    }
}

extension Add {
    init(memory: Memory, instructionAddress: Address) {
        let params = memory.buildParamters(count: 3, instructionAddress: instructionAddress)
        guard params[2].isAddress else {
            fatalError("Add instruction parameter 2 should be an address")
        }
        self.init(p1: params[0], p2: params[1], destination: params[2])
    }
}

extension Mult {
    init(memory: Memory, instructionAddress: Address) {
        let params = memory.buildParamters(count: 3, instructionAddress: instructionAddress)
        guard params[2].isAddress else {
            fatalError("Mult instruction parameter 2 should be an address")
        }
        self.init(p1: params[0], p2: params[1], destination: params[2])
    }
}

extension Read {
    init(memory: Memory, instructionAddress: Address) {
        let params = memory.buildParamters(count: 1, instructionAddress: instructionAddress)
        guard params[0].isAddress else {
            fatalError("Read instruction parameter 0 should be an address")
        }
        self.init(destination: params[0])
    }
}

extension Write {
    init(memory: Memory, instructionAddress: Address) {
        let params = memory.buildParamters(count: 1, instructionAddress: instructionAddress)
        self.init(parameter: params[0])
    }
}

extension Jump {
    static func isInverted(_ inverted: Bool) -> (Memory, Address) -> Jump {
        return { memory, instructionAddress in
            let params = memory.buildParamters(count: 2, instructionAddress: instructionAddress)
            return Jump(isInverted: inverted, predicate: params[0], destination: params[1])
        }
    }
}

extension Comparison {
    static func kind(_ kind: Comparison.Kind) -> (Memory, Address) -> Comparison {
        return { memory, instructionAddress in
            let params = memory.buildParamters(count: 3, instructionAddress: instructionAddress)
            guard params[2].isAddress else {
                fatalError("Comparison instruction parameter 2 should be an address")
            }
            return Comparison(kind: kind, p1: params[0], p2: params[1], destination: params[2])
        }
    }
}

extension AdjustBase {
    init(memory: Memory, instructionAddress: Address) {
        let params = memory.buildParamters(count: 1, instructionAddress: instructionAddress)
        self.init(adjustement: params[0])
    }
}

extension Memory {
    func buildParamters(count: Int, instructionAddress: Address) -> [Parameter] {
        let parameterModes = ParameterModes(instruction: self[instructionAddress])

        return parameterModes.lazy
            .prefix(count)
            .enumerated().map { pair -> Parameter in
                let (idx, mode) = pair

                let value = self[instructionAddress + idx + 1]
                switch mode {
                case .position:
                    return .position(value)
                case .immediate:
                    return .immediate(value)
                case .relative:
                    return .relative(value)
                }
            }
    }
}

extension ParameterModes {
    init(instruction: Int) {
        let modes =
            (instruction / 100)
                .digits()
                .reversed()
                .compactMap(ParameterMode.init)
        self.init(modes: modes)
    }
}



extension Int {
    func digits() -> [Int] {
        var x = self
        var digits = [Int]()
        while x > 0 {
            digits.append(x % 10)
            x = x / 10
        }
        return digits.reversed()
    }
}
