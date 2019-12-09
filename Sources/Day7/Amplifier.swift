import Foundation
import Day5


struct Amplifier {
    var program: Program
    var phase: Int
    private let isolation: DispatchQueue

    init(name: String, program: Program, phase: Int) {
        self.isolation = DispatchQueue(label: "Amplifier.isolation.\(name)")
        self.program = program
        self.phase = phase
    }
}

extension Amplifier {
    init(name: String, code: Memory, phase: Int = 0) {
        let p = Program(memory: code)

        self.init(name: name, program: p, phase: phase)
    }

    func run(io: IO, handler: @escaping () -> Void = {}) {
        isolation.async {
            var toRun = self.program

            let input =  prepend(values: [self.phase], to: io.input)
            let io = IO(input: input, output: io.output)

            toRun.run(io: io)
            handler()
        }
    }
}

public struct Board {
    var run: (Int) -> Int

    func run(input: Int) -> Int {
        run(input)
    }

    static func linear(code: Memory, phases: [Int]) -> Board {
        let amplifiers = phases.enumerated().map { pair -> Amplifier in
              let (idx, phase) = pair
              return Amplifier(name: "\(idx)", code: code, phase: phase)
        }

        let pipes = (0..<(phases.count - 1)).map { _ in Pipe() }

        return Board { inputSignal in
            var result: Int?
            var group = DispatchGroup()
            group.enter()

            let boardInput: Input = arbitraryInput(values: [inputSignal])

            let boardOutput: Output = {
                result = $0
                group.leave()
            }

            amplifiers.enumerated().forEach { pair in
                let (idx, amp) = pair

                func input(for idx: Int) -> Input {
                    if idx == 0 {
                        return boardInput
                    } else {
                        return pipes[idx - 1].end
                    }
                }

                func output(for idx: Int) -> Output {
                    if idx == amplifiers.count - 1 {
                        return boardOutput
                    } else {
                        return pipes[idx].start
                    }
                }

                let io = IO(input: input(for: idx), output: output(for: idx))
                amp.run(io: io)
            }

            group.wait()
            return result!
        }
    }


    static func feedbackLoop(code: Memory, phases: [Int]) -> Board {
        let amplifiers = phases.enumerated().map { pair -> Amplifier in
            let (idx, phase) = pair
            return Amplifier(name: "\(idx)", code: code, phase: phase)
        }

        let pipes = (0..<phases.count).map { _ in Pipe() }

        return Board { inputSignal in
            var outputs = [Int]()
            var group = DispatchGroup()

            let boardOutput: Output = {
                outputs.append($0)
                pipes.last?.start($0)
            }

            amplifiers.enumerated().forEach { pair in
                let (idx, amp) = pair

                group.enter()

                func input(for idx: Int) -> Input {
                    if idx == 0 {
                        return prepend(values: [inputSignal], to: pipes.last!.end)
                    } else {
                        return pipes[idx - 1].end
                    }
                }

                func output(for idx: Int) -> Output {
                    if idx == amplifiers.count - 1 {
                        return boardOutput
                    } else {
                        return pipes[idx].start
                    }
                }

                let io = IO(input: input(for: idx), output: output(for: idx))

                amp.run(io: io) {
                    group.leave()
                }
            }

            group.wait()
            return outputs.last!
        }
    }
}

public func maxLinearOutput(for code: Memory, numberOfAmplifier: Int) -> Int? {
    let phaseValues = (0..<numberOfAmplifier).map { $0 }
    return maxOutput(for: code, phaseValues: phaseValues, boardBuilder: Board.linear(code:phases:))
}

public func maxFeedbackLoopOutput(for code: Memory, phaseRange: Range<Int>) -> Int? {
    let phaseValues = phaseRange.map { $0 }
    return maxOutput(for: code, phaseValues: phaseValues, boardBuilder: Board.feedbackLoop(code:phases:))
}

public func maxOutput(for code: Memory, phaseValues: [Int], boardBuilder: (Memory, [Int]) -> Board) -> Int? {
       // calculate all the possible phase comfbination given our pool of available values
       let phaseCombination = combinations(pool: phaseValues)

       let allOutputs = phaseCombination.map { phases -> Int? in
           let board = boardBuilder(code, phases)
           return board.run(input: 0)
       }

       return allOutputs.compactMap { $0 }.max()

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
