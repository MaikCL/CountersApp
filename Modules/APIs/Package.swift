// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "APIs",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "APIs",
            targets: ["APIs"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "APIs",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "APIsTests",
            dependencies: ["APIs"]),
    ]
)
