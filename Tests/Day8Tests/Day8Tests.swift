import XCTest
@testable import Day8

final class Day8Tests: XCTestCase {
    func testSampleImage1() throws {
        let dimension = Dimension(width: 3, height: 2)
        let image = try SpaceImage(string: "123456789012", dimension: dimension)

        let expected = SpaceImage(layers: [
            Layer(pixels: [1,2,3,4,5,6], dimension: dimension),
            Layer(pixels: [7,8,9,0,1,2], dimension: dimension)
        ])

        XCTAssertEqual(expected, image)
    }

    func testFlatten() throws {
        let dimension = Dimension(width: 2, height: 2)
        let image = SpaceImage(layers: [
            Layer(pixels: [0,2,2,2], dimension: dimension),
            Layer(pixels: [1,1,2,2], dimension: dimension),
            Layer(pixels: [2,2,1,2], dimension: dimension),
            Layer(pixels: [0,0,0,0], dimension: dimension),
        ])

        XCTAssertEqual(image.flatten(), Layer(pixels: [0,1,1,0], dimension: dimension))
    }
}
