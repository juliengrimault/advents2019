import Foundation

public struct IO {
    public var input: Input
    public var output: Output

    public init(input: @escaping Input, output: @escaping Output) {
        self.input = input
        self.output = output
    }
}

public typealias Input = () -> Int
public typealias Output = (Int) -> Void

public let interractiveIO: IO = {
    return IO(input: STDIN(), output: STDOUT())
}()

public func valuesIO(input: [Int], output: @escaping Output = STDOUT()) -> IO {
    return IO(input: arbitraryInput(values: input), output: output)
}

/// Mark - Input Implementations

public func STDIN() -> Input {
    return {
        guard
            let line = readLine(),
            let value = Int(line) else {
                print("input was not an integer")
                fatalError()
        }
        return value
    }
}

public func arbitraryInput(values: [Int]) -> Input {
    var v = values
    return {
        v.removeFirst()
    }
}


public func prepend(values: [Int], to other: @escaping Input) -> Input {
    var remaining = values
    return {
        if let v = remaining.first {
            remaining.removeFirst()
            return v
        } else {
            return other()
        }
    }
}

/// Mark - Output Implementation

public func STDOUT() -> Output {
    return { value in
        print(value)
    }
}

