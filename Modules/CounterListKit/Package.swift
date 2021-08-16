// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CounterListKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CounterListKit",
            targets: ["CounterListKit"]),
    ],
    dependencies: [
        .package(name: "Altair-MDK", url: "https://github.com/mzapatae/AltairMDK-iOS.git", from: "1.0.0"),
        .package(url: "https://github.com/hmlongco/Resolver.git", from: "1.4.1"),
        .package(name: "DesignKit", path: "../DesignKit"),
        .package(name: "CounterKit", path: "../CounterKit"),
        .package(name: "NewCounterKit", path: "../NewCounterKit"),
    ],
    targets: [
        .target(
            name: "CounterListKit",
            dependencies: [
                "Altair-MDK",
                "Resolver",
                "DesignKit",
                "CounterKit",
                "NewCounterKit"
            ],
            path: "Sources",
            resources: [.process("Resources")]),
        .testTarget(
            name: "CounterListTests",
            dependencies: ["CounterListKit"]),
    ]
)
