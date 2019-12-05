import Foundation

enum Direction: String {
    case up = "U"
    case down = "D"
    case left = "L"
    case right = "R"
}

struct Move {
    var direction: Direction
    var distance: Int
}

func parseMoves(_ input: String) -> [Move] {
    input
        .split(separator: ",")
        .map(String.init)
        .compactMap(Move.parseString)
}

extension Move {
    static func parseString(input: String) -> Move? {
        let scanner = Scanner(string: input)
        return scanner.scanMove()
    }
}

extension Scanner {
    func scanMove() -> Move? {
        guard
            let c = scanCharacter(),
            let direction = Direction(rawValue: "\(c)"),
            let distance = scanInt() else {
                return nil
        }
        return Move(direction: direction, distance: distance)
    }
}


extension Board {
    public static func makeFromInput(_ input: String) -> Board? {
        let wires = input.split(separator: "\n").map(String.init)
        guard wires.count == 2 else {
            return nil
        }

        let wire1 = Path(moves: parseMoves(wires[0]))
        let wire2 = Path(moves: parseMoves(wires[1]))

        return Board(wire1: wire1, wire2: wire2)
    }
}


