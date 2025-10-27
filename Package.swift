// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenAQ",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "OpenAQ",
            targets: ["OpenAQ"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "OpenAQ",
            dependencies: []),
        .testTarget(
            name: "OpenAQTests",
            dependencies: ["OpenAQ"]),
    ]
)
