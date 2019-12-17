import Foundation

enum Parameter: Equatable {
    // the parameter refers to an address in the program memory
    case position(Address)

    // the parameter should be interepreted as the raw value
    case immediate(Int)

    // the parameter is an offset from the base address
    case relative(Int)

    func value(memory: Memory, base: Address) -> Int {
        switch self {
        case let .position(address):
            return memory[address]
        case let .immediate(value):
            return value
        case let .relative(offset):
            return memory[base + offset]
        }
    }

    func address(base: Address) -> Address? {
        switch self {
        case .immediate:
            return nil
        case let .position(address):
            return address
        case let .relative(offset):
            return base + offset
        }
    }

    var isAddress: Bool {
        switch self {
        case .immediate:
            return false
        case .position, .relative:
            return true
        }
    }
}

enum ParameterMode: Int {
    case position = 0
    case immediate = 1
    case relative = 2
}

struct ParameterModes: Sequence {
    var modes: [ParameterMode]

    func makeIterator() -> ParameterModes.Iterator {
        ParameterModes.Iterator(modes: ArraySlice(modes))
    }

    struct Iterator: IteratorProtocol {
        var modes: ArraySlice<ParameterMode>

        mutating func next() -> ParameterMode? {
            if let first = modes.first {
                modes = modes.dropFirst()
                return first
            }

            return .position
        }
    }
}
