import Day1
import Day2
import Day3
import Day4
import Day5
import Day6
import Day7
import Day8
import Foundation

enum Option: String, Equatable {
    case day1
    case day2
    case day2Part2
    case day3
    case day4
    case day5
    case day6
    case day7
    case day8
    case day9
}

let args = CommandLine.arguments.dropFirst()
guard let arg = args.first else {
    print("No argument provided")
    exit(1)
}

guard let option = Option(rawValue: arg) else {
    print("unable to parse argument \(arg)")
    exit(1)
}

switch option {
case .day1:
    let f = fuelRequired(input: day1Input)
    print("fuel required: \(f)")

    case .day2:
        let p = try LegacyProgram(codes: program1).restoredTo1202ProgramAlarm()
        let endProgram = try p.afterRunning()
        print("Day 2 result: \(endProgram.output)")

    case .day2Part2:
        let p = LegacyProgram(codes: program2)
        let solver = ProgramSolver(program: p)
        guard let (noun, verb) = try solver.solve(for: 19690720) else {
            print("no solution found :(")
            exit(1)
        }

        let result = noun * 100 + verb
        print("Day 2 - part 2 result: \(result)")

    case .day3:
        guard let board = Board.makeFromInput(day3Input) else {
            print("bad input")
            exit(1)
        }
        
        let distance = board.closestIntersectionDistance
        print("Day 3 - closest intersection distance: \(String(describing:distance))")
        let time = board.fastestIntersection
        print("Day 3 - fastest intersection: \(String(describing:time))")

    case .day4:
        let generator = PasswordGenerator(range: 206938...679128, valid: isValid)
        let count = generator.reduce(0) { acc, _ in acc + 1 }
        print("Day 4 - number of passwords: \(count)")

        let generator2 = PasswordGenerator(range: 206938...679128, valid: isValid2)
        let count2 = generator2.reduce(0) { acc, _ in acc + 1 }
        print("Day 4 part 2 - number of passwords: \(count2)")

    case .day5:
        var program = Program(memory: programDay5)
        let io: IO = valuesIO(input: [1])
        program.run(io: io)

        let io2: IO = valuesIO(input: [5])
        var program2 = Program(memory: programDay5)
        program2.run(io: io2)

    case .day6:
        let solarSystem = SolarSystem.makeFromMap(solarMap)
        print("number of orbits: \(solarSystem.allOrbits())")

        guard
            let start = solarSystem.planet("YOU")?.orbiting,
            let end = solarSystem.planet("SAN")?.orbiting else {
                print("unable to find start and end planets")
                exit(1)
        }

        guard let path = solarSystem.path(from: start, to: end) else {
            print("unable to build path from \(start.identifier) to \(end.identifier)")
            exit(1)
        }
        print("number of transfers required: \(path.count - 1)")

    case .day7:
        let maxLinear = maxLinearOutput(for: programDay7, numberOfAmplifier: 5)
        print("max linear thrust: \(String(describing: maxLinear))")

        let maxLoop = maxFeedbackLoopOutput(for: programDay7, phaseRange: 5..<10)
        print("max feedback loop thrust: \(String(describing: maxLoop))")

    case .day8:
        let dimension = Day8.Dimension(width: 25, height: 6)
        guard let image = try? SpaceImage(string: image1Data, dimension: dimension) else {
            fatalError()
        }
        let mins0 = image.layers.enumerated().reduce(into: (idx: 0, count: Int.max)) { mins, pair in
            let (idx, layer) = pair
            let countOf0 = layer.pixels.filter { $0 == .black }.count
            if countOf0 < mins.count {
                mins = (idx, countOf0)
            }
        }

        let onesAndTwos = image.layers[mins0.idx].pixels.reduce(into: (0,0)) { pair, pixel in
            if pixel == .white {
                pair.0 += 1
            } else if pixel == .transparent {
                pair.1 += 1
            }
        }
        print("Layer with minimum of 0s = \(mins0.idx), n=\(onesAndTwos.0 * onesAndTwos.1)")

        let flat = image.flatten()
        print("\(flat)")

    case .day9:
        var p = Program(memory: day9Program)
        print("part1:")
        let io: IO = valuesIO(input: [1])
        p.run(io: io)

        var p2 = Program(memory: day9Program)
        print("part2:")
        let io2: IO = valuesIO(input: [2])
        p2.run(io: io2)
}
