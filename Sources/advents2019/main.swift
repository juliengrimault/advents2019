import Day1
import Day2
import Foundation

enum Option: String, Equatable {
    case day1
    case day2
    case day2Part2
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
        let p = try Program(codes: program1).restoredTo1202ProgramAlarm()
        let endProgram = try p.afterRunning()
        print("Day 2 result: \(endProgram.output)")

    case .day2Part2:
        let p = Program(codes: program2)
        let solver = ProgramSolver(program: p)
        guard let (noun, verb) = try solver.solve(for: 19690720) else {
            print("no solution found :(")
            exit(1)
        }

        let result = noun * 100 + verb
        print("Day 2 - part 2 result: \(result)")

    
}
