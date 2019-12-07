import Foundation

enum Parameter: Equatable {
    case position(Address)
    case immediate(Int)

    func value(memory: Memory) -> Int {
        switch self {
        case let .position(address):
            return memory[address]
        case let .immediate(value):
            return value
        }
    }
}

extension Parameter {
    var position: Address? {
        get {
            guard case let .position(value) = self else { return nil}
            return value
        }
        set {
            guard case  .position = self, let value = newValue  else { return }
            self = .position(value)
        }
    }
}

enum ParameterMode: Int {
    case position = 0
    case immediate = 1
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
