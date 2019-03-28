// swift-tools-version:5.0

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
    ],
    swiftLanguageVersions: [.v4_2, .v5]
)
