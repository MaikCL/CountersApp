// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CounterList",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CounterList",
            targets: ["CounterList"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "CounterList",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "CounterListTests",
            dependencies: ["CounterList"]),
    ]
)
