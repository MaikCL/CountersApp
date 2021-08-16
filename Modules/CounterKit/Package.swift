// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CounterKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CounterKit",
            targets: ["CounterKit"]),
    ],
    dependencies: [
        .package(name: "Altair-MDK", url: "https://github.com/mzapatae/AltairMDK-iOS.git", from: "1.0.0"),
        .package(url: "https://github.com/hmlongco/Resolver.git", from: "1.4.1"),
        .package(name: "APIsKit", path: "../APIsKit"),
    ],
    targets: [
        .target(
            name: "CounterKit",
            dependencies: [
                "Altair-MDK",
                "Resolver",
                "APIsKit",
            ],
            path: "Sources",
            resources: [.process("Resources")]),
        .testTarget(
            name: "CounterTests",
            dependencies: ["CounterKit", "Altair-MDK", "Resolver"]),
    ]
)
