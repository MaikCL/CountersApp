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
        .package(name: "Altair-MDK", url: "https://github.com/mzapatae/AltairMDK-iOS.git", from: "1.0.0"),
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
