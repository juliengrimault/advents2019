import Foundation


extension SolarSystem {
    public static func makeFromMap(_ map: String) -> SolarSystem {
        let relations = map.split(separator: "\n")

        func scanRelationship(_ string: Substring) -> (Identifier, Identifier) {
            let identifiers = string.split(separator: ")")
            guard identifiers.count == 2 else {
                fatalError("invalid map data")
            }
            return (String(identifiers[0]), String(identifiers[1]))
        }

        let planets = relations.reduce(into: [String: Planet]()) { planets, relation in
            let (id1, id2) = scanRelationship(relation)
            let p1 = planets.findOrInsert(id: id1)
            let p2 = planets.findOrInsert(id: id2)
            p2.orbiting = p1
            p1.orbitedBy.append(p2)
        }

        guard let com = planets[Identifier.centerOfMass] else {
            fatalError("no COM in map data")
        }
        return SolarSystem(planets: planets, center: com)
    }
}

extension Dictionary where Key == String, Value == Planet {
    mutating func findOrInsert(id: Identifier) -> Planet {
        if let p = self[id] {
            return p
        } else {
            let p = Planet(identifier: id)
            self[id] = p
            return p
        }
    }
}
