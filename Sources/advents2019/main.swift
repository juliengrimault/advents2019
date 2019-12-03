import Day1
import Foundation

enum Option: String, Equatable {
    case day1
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
}
