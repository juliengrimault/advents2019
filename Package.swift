// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "advents2019",
    products: [
        .executable(name: "advents", targets: ["advents2019"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "advents2019",
            dependencies: ["Day1"]),
        .target(
            name: "Day1",
            dependencies: []),
    ]
)
