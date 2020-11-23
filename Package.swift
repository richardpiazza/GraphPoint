// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        .package(url: "https://github.com/richardpiazza/Swift2D", .upToNextMinor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "GraphPoint",
            dependencies: ["Swift2D"]),
        .target(
            name: "GraphPointUI",
            dependencies: ["GraphPoint"]),
        .testTarget(
            name: "GraphPointTests",
            dependencies: ["GraphPoint"]),
    ],
    swiftLanguageVersions: [.v5]
)
