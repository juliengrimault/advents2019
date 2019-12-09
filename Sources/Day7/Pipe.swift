import Day5
import Foundation


/// Connects the output of 1 program to the input of another
class Pipe {
    var start: Output {
        return { v in
            self.write(v)
        }
    }

    var end: Input {
        return {
            self.read()
        }
    }

    let isolation = DispatchQueue(label: "Pipe.isolation")
    let semaphore: DispatchSemaphore
    private(set) var values: [Int]

    init(values: [Int] = []) {
        self.semaphore = DispatchSemaphore(value: values.count)
        self.values = values
    }

    func read() -> Int {
        func value() -> Int? {
            isolation.sync {
                if let v = values.first {
                    defer {
                        values.removeFirst()
                    }
                    return v
                } else {
                    return nil
                }
            }
        }

        var v = value()
        while v == nil {
            self.semaphore.wait()
            v = value()
        }

        return v!
    }

    func write(_ value: Int) {
        isolation.async {
            self.values.append(value)
            self.semaphore.signal()
        }
    }
}
