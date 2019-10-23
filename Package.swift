// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "GraphPoint",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v4),
    ],
    products: [
        .library(
            name: "GraphPoint",
            targets: ["GraphPoint", "GraphPointUI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GraphPoint",
            dependencies: []),
        .target(
            name: "GraphPointUI",
            dependencies: ["GraphPoint"]),
        .testTarget(
            name: "GraphPointTests",
            dependencies: ["GraphPoint"]),
    ],
    swiftLanguageVersions: [.v5]
)
