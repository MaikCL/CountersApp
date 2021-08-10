// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "APIsKit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "APIsKit",
            targets: ["APIsKit"]),
    ],
    dependencies: [
        .package(name: "Altair-MDK", url: "https://github.com/mzapatae/AltairMDK-iOS.git", .branch("feature/required-extensions")),
    ],
    targets: [
        .target(
            name: "APIsKit",
            dependencies: ["Altair-MDK"],
            path: "Sources"),
        .testTarget(
            name: "APIsTests",
            dependencies: ["APIsKit"]),
    ]
)
