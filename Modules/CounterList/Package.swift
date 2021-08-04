// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CounterList",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CounterList",
            targets: ["CounterList"]),
    ],
    dependencies: [
        .package(name: "Altair-MDK", url: "https://github.com/mzapatae/AltairMDK-iOS.git", .branch("feature/required-extensions")),
        .package(url: "https://github.com/hmlongco/Resolver.git", from: "1.4.1"),
        .package(name: "APIs", path: "../APIs"),
        .package(name: "Design", path: "../Design"),
    ],
    targets: [
        .target(
            name: "CounterList",
            dependencies: [
                "Altair-MDK",
                "Resolver",
                "APIs",
                "Design"
            ],
            path: "Sources",
            resources: [.process("Resources")]),
        .testTarget(
            name: "CounterListTests",
            dependencies: ["CounterList"]),
    ]
)
