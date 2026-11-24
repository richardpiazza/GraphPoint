// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GraphPoint",
    platforms: [
        .macOS(.v13),
        .macCatalyst(.v16),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1), // .v2 ~ iOS 18
    ],
    products: [
        .library(
            name: "GraphPoint",
            targets: ["GraphPoint"]),
    ],
    dependencies: [
        .package(url: "https://github.com/richardpiazza/Swift2D", branch: "feature/swift-6.2"),
    ],
    targets: [
        .target(
            name: "GraphPoint",
            dependencies: ["Swift2D"]),
        .testTarget(
            name: "GraphPointTests",
            dependencies: ["GraphPoint"]),
    ],
    swiftLanguageModes: [.v5],
)
