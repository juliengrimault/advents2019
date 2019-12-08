import Foundation

public typealias Identifier = String

extension Identifier {
    public static var centerOfMass: Identifier {
        return "COM"
    }
}

public final class Planet {
    public let identifier: Identifier

    public var orbiting: Planet?
    public var orbitedBy: [Planet] = []

    public init(identifier: Identifier) {
        self.identifier = identifier
    }
}
