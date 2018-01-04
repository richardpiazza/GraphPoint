// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GraphPoint",
    products: [
        .library(name: "GraphPoint", targets: ["GraphPoint"]),
        ],
    dependencies: [
        ],
    targets: [
        .target(name: "GraphPoint", dependencies: [], path: "Sources/GraphPoint"),
        .testTarget(name: "GraphPointTests", dependencies: ["GraphPoint"], path: "Tests/GraphPointTests"),
    ]
)
