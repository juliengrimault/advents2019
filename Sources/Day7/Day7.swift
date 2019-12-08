import Foundation
import Day5


struct Amplifier {
    var program: Program

    var phase: Int
}

extension Amplifier {
    init(code: Memory, phase: Int = 0) {
        self.program = Program(memory: code, io: .interractive)
        self.phase = phase
    }

    func run(inputSignal: Int) throws -> Int {
        let inputs = [phase, inputSignal]

        var toRun = program
        toRun.io = .values(input: inputs, output: StoreOutput())

        toRun.run()

        let values = (toRun.io.output as! StoreOutput).values
        guard let v = values.first else {
            throw Error.noReturnedValue
        }

        return v
    }
}

extension Amplifier {
    enum Error: Swift.Error {
        case noReturnedValue
    }
}


public func maxOutput(for code: Memory, numberOfAmplifier: Int) -> Int? {
    let phaseValues = (0..<numberOfAmplifier).map { $0 }

    // calculate all the possible phase comfbination given our pool of available values
    let phaseCombination = combinations(pool: phaseValues)

    let allOutputs = phaseCombination.map { phases -> Int? in
        output(for: code, phaseSettings: phases)
    }

    return allOutputs.compactMap { $0 }.max()
}

func output(for code: Memory, phaseSettings: [Int]) -> Int? {
    let amplifiers = phaseSettings.map { phase in
        Amplifier(code: code, phase: phase)
    }

    // run the signal through our series of amplifiers
    return try? amplifiers.run(input: 0)
}

extension Array where Element == Amplifier {
    func run(input: Int) throws -> Int {
        try reduce(input) { signal, amplifier in
            try amplifier.run(inputSignal: signal)
        }
    }
}


func combinations(pool: [Int]) -> [[Int]] {
    guard !pool.isEmpty else {
        return [[]]
    }

    var result: [[Int]] = []
    for idx in pool.indices {
        let value = pool[idx]

        let rest: [Int] = {
            var r = pool
            r.remove(at: idx)
            return r
        }()

        let c = combinations(pool: rest)

        result += c.map { [value] + $0 }
    }

    return result
}
