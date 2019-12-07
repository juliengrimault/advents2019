import Foundation


public struct IO {
    public var input: Input
    public var output: Output

    public init(input: Input, output: Output) {
        self.input = input
        self.output = output
    }
}

extension IO {
    public static var interractive: IO {
        return IO(input: IO.stdin, output: IO.stdout)
    }

    public static func values(input: [Int], output: Output) -> IO {
        return IO(input: ArbitraryInput(values: input), output: output)
    }
}


public protocol Input {
    mutating func read(_ message: String) -> Int?
}

public protocol Output {
    mutating func write(_ value: Int)
}


/// Mark - Input Implementations

extension IO {
    public static var stdin: Input {
        return STDIN()
    }
}

public struct STDIN: Input {
    public mutating func read(_ message: String) -> Int? {
        print(message)
        guard
            let line = readLine(),
            let value = Int(line) else {
                print("input was not an integer")
                return nil
        }
        return value
    }
}

public struct ArbitraryInput: Input {
    public var values: [Int]

    public init(values: [Int]) {
        self.values = values
    }

    public mutating func read(_ message: String) -> Int? {
        guard let v = values.first else {
            return nil
        }
        values.removeFirst()
        return v
    }
}

/// Mark - Output Implementation

extension IO {
    public static var stdout: Output {
        return STDOUT()
    }
}

public struct STDOUT: Output {
    public mutating func write(_ value: Int) {
        print(value)
    }
}

public struct StoreOutput: Output {
    public private(set) var values: [Int]

    public init() {
        self.values = []
    }

   public mutating func write(_ value: Int) {
    values.append(value)
    }
}

public struct MultiplexOutput<O1, O2> where O1: Output, O2: Output {
    public var output1: O1
    public var output2: O2

    public init(_ o1: O1, _ o2: O2) {
        self.output1 = o1
        self.output2 = o2
    }

    mutating func write(_ value: Int) {
        output1.write(value)
        output2.write(value)
     }
}
