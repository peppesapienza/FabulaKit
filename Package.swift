// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FabulaKit",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "FabulaKit",
            targets: ["FabulaCore"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FabulaCore",
            dependencies: []),
        .testTarget(
            name: "CoreTests",
            dependencies: ["FabulaCore"]),
    ]
)
