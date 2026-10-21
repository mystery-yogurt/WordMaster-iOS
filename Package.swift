// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WordMaster",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "WordMaster",
            targets: ["WordMaster"]
        ),
    ],
    targets: [
        .target(
            name: "WordMaster",
            path: "Sources/WordMaster"
        ),
    ]
)
