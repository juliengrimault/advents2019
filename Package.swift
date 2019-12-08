// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "advents2019",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "advents", targets: ["advents2019"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "advents2019",
            dependencies: ["Day1", "Day2", "Day3", "Day4", "Day5", "Day6", "Day7"]),
        .target(
            name: "Day1",
            dependencies: []),
        .target(
            name: "Day2",
            dependencies: []),
        .testTarget(
            name: "Day2Tests",
            dependencies: ["Day2"]),
        .target(
            name: "Day3",
            dependencies: []),
        .testTarget(
            name: "Day3Tests",
            dependencies: ["Day3"]),
        .target(
            name: "Day4",
            dependencies: []),
        .testTarget(
            name: "Day4Tests",
            dependencies: ["Day4"]),
        .target(
            name: "Day5",
            dependencies: []),
        .testTarget(
            name: "Day5Tests",
            dependencies: ["Day5"]),
        .target(
            name: "Day6",
            dependencies: []),
        .testTarget(
            name: "Day6Tests",
            dependencies: ["Day6"]),
        .target(
            name: "Day7",
            dependencies: ["Day5"]),
        .testTarget(
            name: "Day7Tests",
            dependencies: ["Day7"]),
    ]
)
