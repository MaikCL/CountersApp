// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "NewCounter",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "NewCounter",
            targets: ["NewCounter"]),
    ],
    dependencies: [

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "NewCounter",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "NewCounterTests",
            dependencies: ["NewCounter"]),
    ]
)
