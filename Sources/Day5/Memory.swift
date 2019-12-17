import Foundation

public struct Memory: RandomAccessCollection {
    var underlying: [Int]

    public var count: Int {
        underlying.count
    }

    public var startIndex: Int {
        underlying.startIndex
    }

    public var endIndex: Int {
        underlying.endIndex
    }

    public func index(after i: Int) -> Int {
        underlying.index(after: i)
    }

    public func index(before i: Int) -> Int {
        underlying.index(before: i)
    }

    public subscript(position: Int) -> Int {
        get {
            // any memory beyond what's already allocated is 0
            guard position < underlying.endIndex else {
                return 0
            }
            return underlying[position]
        }
        set {
            resizeIfNeeded(to: position)
            underlying[position] = newValue
        }
    }

    public init(_ underlying: [Int]) {
        self.underlying = underlying
    }

    private mutating func resizeIfNeeded(to idx: Int) {
        var lastIdx = underlying.endIndex
        while idx >= lastIdx {
            underlying += Array(repeating: 0, count: underlying.count)
            lastIdx = underlying.endIndex
        }
    }
}

extension Memory: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Int...) {
        self.init(elements)
    }
}
