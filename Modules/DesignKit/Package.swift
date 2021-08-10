// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "DesignKit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "DesignKit",
            targets: ["DesignKit"]),
    ],
    dependencies: [
        .package(name: "Altair-MDK", url: "https://github.com/mzapatae/AltairMDK-iOS.git", .branch("feature/required-extensions")),
    ],
    targets: [
        .target(
            name: "DesignKit",
            dependencies: ["Altair-MDK"],
            path: "Sources"),
        .testTarget(
            name: "DesignTests",
            dependencies: ["DesignKit"]),
    ]
)
