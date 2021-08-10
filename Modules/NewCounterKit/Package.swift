// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "NewCounterKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "NewCounterKit",
            targets: ["NewCounterKit"]),
    ],
    dependencies: [
        .package(name: "Altair-MDK", url: "https://github.com/mzapatae/AltairMDK-iOS.git", .branch("feature/required-extensions")),
        .package(url: "https://github.com/hmlongco/Resolver.git", from: "1.4.1"),
        .package(name: "APIsKit", path: "../APIsKit"),
        .package(name: "DesignKit", path: "../DesignKit"),
        .package(name: "CounterKit", path: "../CounterKit"),
    ],
    targets: [
        .target(
            name: "NewCounterKit",
            dependencies: [
                "Altair-MDK",
                "Resolver",
                "APIsKit",
                "DesignKit",
                "CounterKit"
            ],
            path: "Sources",
            resources: [.process("Resources")]),
        .testTarget(
            name: "NewCounterTests",
            dependencies: ["NewCounterKit"]),
    ]
)
