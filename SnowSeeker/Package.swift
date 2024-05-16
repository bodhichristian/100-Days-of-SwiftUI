// swift-tools-version: 5.9.0
import PackageDescription

let package = Package(
    name: "SnowSeeker",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SnowSeeker",
            targets: ["SnowSeeker"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Stubs",
            dependencies: [],
            path: "Sources/SnowSeeker"),
        .testTarget(
            name: "SnowSeekerTests",
            dependencies: ["SnowSeeker"],
            path: "Tests"),
    ]
)

