import Foundation


public enum SpaceImageParsingError: Error {
    case invalidData
}

func parsePixels(from input: String) throws -> [Pixel] {
    var pixels = [Pixel]()
    let scanner = Scanner(string: input)
    while !scanner.isAtEnd {
        guard let c = scanner.scanCharacter(),
            c.unicodeScalars.count == 1,
            let unicodeScalar = c.unicodeScalars.first,
            CharacterSet.decimalDigits.contains(unicodeScalar),
            let pixel = Int("\(c)") else {
            throw SpaceImageParsingError.invalidData
        }

        pixels.append(pixel)
    }
    return pixels
}

extension SpaceImage {
    public init(string: String, dimension: Dimension) throws {
        let pixels = try parsePixels(from: string)
        self.init(pixels: pixels, dimension: dimension)
    }
}
