import Foundation

public typealias Pixel = Int

extension Pixel {
    public static var black: Pixel { 0 }
    public static var white: Pixel { 1 }
    public static var transparent: Pixel { 2 }
}

func flattenPixels(above: Pixel, below: Pixel) -> Pixel {
    switch (above, below) {
    case (.transparent, _): return below
    case (_, _): return above
    }
}

public struct SpaceImage: Equatable {
    public var layers: [Layer]

    public init(layers: [Layer]) {
        precondition(zip(layers, layers.dropFirst()).allSatisfy({ $0.0.dimension == $0.1.dimension }))
        self.layers = layers
    }
}

extension SpaceImage {
    public init(pixels: [Pixel], dimension: Dimension) {
        let layerCount = pixels.count / dimension.count
        let layers = (0..<layerCount).map { layerIdx -> Layer in
            let start = layerIdx * dimension.count
            let end = (layerIdx + 1) * dimension.count
            let layerPixels = pixels[start..<end]

            return Layer(pixels: Array(layerPixels), dimension: dimension)
        }

        self.init(layers: layers)
    }
}

extension SpaceImage {
    public func flatten() -> Layer {
        let depthRange = 0..<layers.count

        let layer = layers.first!
        let pixels = layer.pixels.indices.map { pixelIdx in
            depthRange.reduce(Pixel.transparent) { previous, depthIndex -> Pixel in
                let pixel = layers[depthIndex].pixels[pixelIdx]
                return flattenPixels(above: previous, below: pixel)
            }
        }

        return Layer(pixels: pixels, dimension: layer.dimension)
    }
}


public struct Dimension: Equatable {
    public var width: Int
    public var height: Int

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    public var count: Int {
        width * height
    }
}

public struct Layer: Equatable, CustomStringConvertible {
    public var pixels: [Pixel]
    public var dimension: Dimension

    public init(pixels: [Pixel], dimension: Dimension) {
        precondition(pixels.count == dimension.count)

        self.pixels = pixels
        self.dimension = dimension
    }

    public subscript(x: Int, y: Int) -> Pixel {
        get {
            let idx = idxFor(row: y, column: x)
            return pixels[idx]
        }
        set {
            let idx = idxFor(row: y, column: x)
            pixels[idx] = newValue
        }
    }

    private func idxFor(row: Int, column: Int) -> Int {
        row * dimension.width + column
    }

    public var description: String {
        (0..<dimension.height).map { rowIdx -> String in
            let start = rowIdx * dimension.width
            return pixels[start..<start + dimension.width].map { $0.drawRepresentation }.joined()
        }.joined(separator: "\n")
    }
}

extension Pixel {
    var drawRepresentation: String {
        if self == .white { return "1" }
        return " "
    }
}
