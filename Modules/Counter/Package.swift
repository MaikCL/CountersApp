// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Counter",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Counter",
            targets: ["Counter"]),
    ],
    dependencies: [
        .package(name: "Altair-MDK", url: "https://github.com/mzapatae/AltairMDK-iOS.git", .branch("feature/required-extensions")),
        .package(url: "https://github.com/hmlongco/Resolver.git", from: "1.4.1"),
        .package(name: "APIs", path: "../APIs"),
    ],
    targets: [
        .target(
            name: "Counter",
            dependencies: [
                "Altair-MDK",
                "Resolver",
                "APIs",
            ],
            path: "Sources",
            resources: [.process("Resources")]),
        .testTarget(
            name: "CounterTests",
            dependencies: ["Counter"]),
    ]
)
