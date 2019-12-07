import Foundation


enum Instruction: Equatable {
    case add(Add)
    case mult(Mult)
    case read(Read) // read from IO
    case write(Write) // write to IO
    case jump(Jump)
    case comparison(Comparison)
    case halt
}

struct Add: Equatable {
    var p1: Parameter
    var p2: Parameter
    var destination: Address
}

struct Mult: Equatable {
    var p1: Parameter
    var p2: Parameter
    var destination: Address

}

struct Read: Equatable {
    var destination: Address
}

struct Write: Equatable {
    var parameter: Parameter
}

struct Jump: Equatable {
    var isInverted: Bool
    var predicate: Parameter
    var destination: Parameter
}

struct Comparison: Equatable {
    enum Kind: Equatable {
        case lessThan
        case equal
    }
    var kind: Kind
    var p1: Parameter
    var p2: Parameter
    var destination: Address
}
