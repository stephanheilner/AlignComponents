// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SummitPickers",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "SummitPickers",
            targets: ["SummitPickers"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SummitPickers",
            dependencies: []
        ),
    ],
    swiftLanguageVersions: [.v5]
)
