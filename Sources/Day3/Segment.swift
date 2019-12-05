import Foundation

enum Axis {
    case horizontal
    case vertical
}

struct Vect {
    var distance: Int
    var axis: Axis
}

struct Segment {
    var start: Position
    var vect: Vect
}

extension Position {
    func moved(along vect: Vect) -> Position {
        switch vect.axis {
        case .horizontal:
            return Position(x: x + vect.distance, y: y)
        case .vertical:
            return Position(x: x, y: y + vect.distance)
        }
    }
}

extension Segment {
    func contains(position: Position) -> Bool {
        let zeroLengthSegment = Segment(start: position, vect: Vect(distance: 0, axis: .horizontal))
        return intersection(with: zeroLengthSegment) != nil
    }
}

extension Segment {
    var range: ClosedRange<Int> {
        switch vect.axis {
        case .horizontal:
            let x1 = start.x
            let x2 = x1 + vect.distance
            if x1 < x2 {
                return x1...x2
            } else {
                return x2...x1
            }

        case .vertical:
            let y1 = start.y
            let y2 = y1 + vect.distance
            if y1 < y2 {
                return y1...y2
            } else {
                return y2...y1
            }
        }
    }

    func intersection(with other: Segment) -> Segment? {
        switch (self.vect.axis, other.vect.axis) {
        case (.horizontal, .horizontal):
            guard
                start.y == other.start.y,
                range.overlaps(other.range) else { return nil }

            let r = range.clamped(to: other.range)
            return Segment(
                start: Position(x: r.lowerBound, y: start.y),
                vect: Vect(distance: r.upperBound - r.lowerBound, axis: .horizontal)
            )

        case (.vertical, .vertical):
            guard
                start.x == other.start.x,
                range.overlaps(other.range) else { return nil }

            let r = range.clamped(to: other.range)
            return Segment(
                start: Position(x: start.x, y: r.lowerBound),
                vect: Vect(distance: r.upperBound - r.lowerBound, axis: .vertical)
            )

        case (.vertical, .horizontal):
            if range.contains(other.start.y) && other.range.contains(start.x) {
                return Segment(
                    start: Position(x: start.x, y: other.start.y),
                    vect: Vect(distance: 0, axis: .horizontal)
                )
            } else {
                return nil
            }

        case (.horizontal, .vertical):
            if range.contains(other.start.x) && other.range.contains(start.y) {
                return Segment(
                    start: Position(x: other.start.x, y: start.y),
                    vect: Vect(distance: 0, axis: .horizontal)
                )
            } else {
                return nil
            }
        }
    }
}

extension Segment {
    var positions: [Position] {
        var distances: ClosedRange<Int>
        if vect.distance < 0 {
            distances = (vect.distance...0)
        } else {
            distances = (0...vect.distance)
        }
        return distances.map { d in
            start.moved(along: Vect(distance: d, axis: vect.axis))
        }
    }
}

