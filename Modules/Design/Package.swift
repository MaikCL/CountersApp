// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Design",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Design",
            targets: ["Design"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "Design",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "DesignTests",
            dependencies: ["Design"]),
    ]
)
