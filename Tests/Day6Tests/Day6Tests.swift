import XCTest
@testable import Day6

final class Day6Tests: XCTestCase {
    let map = """
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
"""

    func testParsing() {
        let solarSystem = SolarSystem.makeFromMap(map)
        XCTAssertEqual(Set(solarSystem.planets.keys), ["COM", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"])
    }

    func testOrbitGeneration() {
        let s = SolarSystem.makeFromMap(map)

        guard let d = s.planet("D") else {
            XCTFail(); return;
        }
        XCTAssertEqual(s.orbits(for: d), ["C", "B", "COM"])

        guard let l = s.planet("L") else {
            XCTFail(); return;
        }
        XCTAssertEqual(s.orbits(for: l), ["K", "J", "E", "D", "C", "B", "COM"])


        XCTAssertEqual(s.orbits(for: s.center), [])

        XCTAssertEqual(s.allOrbits(), 42)
    }

    let map2 = """
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN
"""
    func testPathFinding() {
        let s = SolarSystem.makeFromMap(map2)

        guard
            let start = s.planet("YOU")?.orbiting,
            let end = s.planet("SAN")?.orbiting else {
            XCTFail(); return
        }

        guard let path = s.path(from: start, to: end) else {
            XCTFail(); return
        }

        XCTAssertEqual(path.map { $0.identifier }, ["K", "J", "E", "D", "I"])
    }
}
