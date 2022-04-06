// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FabulaKit",
    platforms: [.iOS(.v15), .macOS (.v12)],
    products: [
        .library(
            name: "FabulaKit",
            targets: ["FabulaCore", "FabulaChat"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FabulaCore",
            dependencies: []),
        .target(
            name: "FabulaChat",
            dependencies: ["FabulaCore"]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["FabulaCore"]
        ),
        .testTarget(
            name: "ChatTests",
            dependencies: ["FabulaChat"]
        )
    ]
)
