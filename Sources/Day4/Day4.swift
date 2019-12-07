import Foundation


public struct PasswordGenerator: Sequence {
    public var range: ClosedRange<Int>
    public var valid: (Int) -> Bool

    public init(range: ClosedRange<Int>, valid: @escaping (Int) -> Bool) {
        self.range = range
        self.valid = valid
    }

    public func makeIterator() -> Iterator {
        Iterator(rangeIterator: range.makeIterator(), valid: valid)
    }

    public struct Iterator: IteratorProtocol {
        public var rangeIterator: ClosedRange<Int>.Iterator
        public var valid: (Int) -> Bool

        public init(rangeIterator: ClosedRange<Int>.Iterator, valid: @escaping (Int) -> Bool) {
            self.rangeIterator = rangeIterator
            self.valid = valid
        }

        public mutating func next() -> Int? {
            var candidate = rangeIterator.next()
            while let c = candidate {
                if valid(c) {
                    return c
                } else {
                    candidate = rangeIterator.next()
                }
            }
            return nil
        }
    }
}

public func isValid(_ x: Int) -> Bool {
    let digits = x.digits()

    let adjancentsIdentical = zip(digits, digits.dropFirst())
        .lazy
        .contains { $0.0 == $0.1 }

    guard adjancentsIdentical else {
        return false
    }

    let increase = zip(digits, digits.dropFirst()).allSatisfy { $0.0 <= $0.1 }
    guard increase else {
        return false
    }

    return true
}

public func isValid2(_ x: Int) -> Bool {
    let digits = x.digits()

    guard exactly2Adjacents(digits: digits) else {
        return false
    }

    let increase = zip(digits, digits.dropFirst()).allSatisfy { $0.0 <= $0.1 }
    guard increase else {
        return false
    }

    return true
}

private func exactly2Adjacents(digits: [Int]) -> Bool {
    var idx = digits.startIndex

    while idx < digits.endIndex {
        var idx2 = idx + 1
        while idx2 < digits.endIndex, digits[idx2] == digits[idx] {
            idx2 += 1
        }
        if (idx2 - idx) == 2 {
            return true
        }
        idx = idx2
    }

    return false
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

func zip3<C1, C2, C3>(_ a1: C1, _ a2: C2, _ a3: C3) -> [(C1.Element, C2.Element, C3.Element)]
    where
    C1: Sequence, C2: Sequence, C3: Sequence,
    C1.Element == C2.Element, C2.Element == C3.Element {
        zip(zip(a1, a2), a3).map { ($0.0.0, $0.0.1, $0.1) }
}

