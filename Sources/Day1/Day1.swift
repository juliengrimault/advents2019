import Foundation

public func fuelRequired(input: String) -> Int {
    let values = input.split(separator: "\n")
    .map(String.init)
    .compactMap(Int.init)

    let fuelPerModule = values.map(fuelRequired(forMass:))

    let totalFuel = fuelPerModule.reduce(0, +)

    return totalFuel
}

func fuelRequired(forMass m: Int) -> Int {
    (m / 3) - 2
}
