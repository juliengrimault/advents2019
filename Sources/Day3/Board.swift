import Foundation

public struct Board {
    var wire1: Path
    var wire2: Path
}

extension Board {
    public var closestIntersectionDistance: Int? {
        wire1.intersections(with: wire2)
            .map { $0.1 }
            .map { $0.distance(to: .zero) }
            .filter { $0 != 0 }
            .sorted(by: <)
            .first
    }

    public var fastestIntersection: Int? {
       return wire1.intersections(with: wire2)
            .map { $0.0 }
            .filter { $0 != 0 }
            .sorted(by: <)
            .first
    }
}

extension Path {
    func intersections(with otherSegment: Segment, accDistance: Int) -> [(Int, Position)] {
        segments.reduce(into: [(Int, Position)]()) { acc, pair in
            let (d, s) = pair
            if let intersectionSegment = s.intersection(with: otherSegment) {

                // calculate the distanc of each position to the start of both segments
                let intersections = intersectionSegment.positions
                    .map { p -> (Int, Position) in
                        let d1 = p.distance(to: otherSegment.start)
                        let d2 = p.distance(to: s.start)
                        return (accDistance + d + d1 + d2, p)
                    }
                    .sorted(by: { $0.0 < $1.0 })

                acc.append(contentsOf: intersections)
            }
        }
    }
}

extension Path {
    func intersections(with otherPath: Path) -> [(Int, Position)] {
        segments.reduce(into: [(Int, Position)]()) { acc, pair in
            let (distance, segment) = pair
            let intersections = otherPath.intersections(with: segment, accDistance: distance)
            acc.append(contentsOf: intersections)
        }
    }
}

extension Segment {
    func distance(to position: Position) -> Int {
        switch vect.axis {
        case .horizontal:
            let verticalDistance = abs(position.y - start.y)
            let horizontalDistance = range.distance(to: position.x)
            return horizontalDistance + verticalDistance

        case .vertical:
            let verticalDistance = range.distance(to: position.x)
            let horizontalDistance = abs(position.x - start.y)
            return horizontalDistance + verticalDistance
        }
    }
}

extension ClosedRange where Element == Int {
    func distance(to value: Int) -> Int {
        guard !contains(value) else {
            return 0
        }

        if value < lowerBound {
            return lowerBound - value
        } else {
            assert(value > upperBound)
            return value - upperBound
        }
    }
}
