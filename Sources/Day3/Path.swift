import Foundation

struct Path {
    var segments: [(Int, Segment)]
}

struct Position {
    var x: Int
    var y: Int

    static var zero: Position {
        return .init(x: 0, y: 0)
    }

    func distance(to other: Position) -> Int {
        return abs(other.x - x) + abs(other.y - y)
    }
}

extension Path {
    init(moves: [Move]) {
        var position = Position.zero
        var distance = 0

        let segments = moves.reduce(into: [(Int, Segment)]()) { segments, move in

            let newSegment = Segment(start: position, vect: move.vect)

            segments.append((distance, newSegment))

            position = position.moved(by: move)
            distance += abs(newSegment.vect.distance)
        }

        self.init(segments: segments)
    }
}

extension Position {
    func moved(by move: Move) -> Position {
        switch move.direction {
        case .left:
            return Position(x: x - move.distance, y: y)

        case .right:
            return Position(x: x + move.distance, y: y)

        case .up:
            return Position(x: x, y: y + move.distance)

        case .down:
            return Position(x: x, y: y - move.distance)
        }
    }
}

extension Move {
    var vect: Vect {
        switch direction {
        case .up:
            return Vect(distance: distance, axis: .vertical)
        case .down:
            return Vect(distance: -distance, axis: .vertical)
        case .left:
            return Vect(distance: -distance, axis: .horizontal)
        case .right:
            return Vect(distance: distance, axis: .horizontal)
        }
    }
}
