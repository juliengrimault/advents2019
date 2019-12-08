import Foundation

public struct SolarSystem {
    public var planets: [Identifier: Planet]
    public var center: Planet
}

extension SolarSystem {
    public func planet(_ id: Identifier) -> Planet? {
        planets[id]
    }
}


extension SolarSystem {
    public func orbits(for planet: Planet) -> [Identifier] {
        var planets = [Identifier]()

        var planet = planet.orbiting
        while let p = planet {
            planets.append(p.identifier)
            planet = p.orbiting
        }

        return planets
    }

    public func allOrbits() -> Int {
        orbits(for: center, visited: 0)
    }

    private func orbits(for planet: Planet, visited: Int) -> Int {
        planet.orbitedBy.reduce(visited) { acc, p in
            acc + orbits(for: p, visited: visited + 1)
        }
    }

}

public typealias Path = [Planet]

extension SolarSystem {
    public func path(from origin: Planet, to destination: Planet) -> Path? {
        var visited = Set<Identifier>()
        var toVisit: [Path] = [[origin]]

        while let path = toVisit.first {
            toVisit.removeFirst()

            let planet = path.last!

            visited.insert(planet.identifier)

            if planet.identifier == destination.identifier {
                return path
            } else {
                toVisit += planet
                    .neighbors
                    .filter { !visited.contains($0.identifier) }
                    .map { path + [$0] }
            }
        }

        return nil
    }
}

extension Planet {
    var neighbors: [Planet] {
        if let orbiting = orbiting {
            return orbitedBy + [orbiting]
        } else {
            return orbitedBy
        }
    }
}
