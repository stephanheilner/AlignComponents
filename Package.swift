// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlignComponents",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "AlignComponents",
            targets: ["AlignComponents"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AlignComponents",
            dependencies: []
        ),
    ],
    swiftLanguageVersions: [.v5]
)
