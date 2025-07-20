// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OtherApps",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "OtherApps",
            targets: ["OtherApps"]
        ),
    ],
    dependencies: [
        // No external dependencies required - uses only native SwiftUI and Foundation
    ],
    targets: [
        .target(
            name: "OtherApps",
            dependencies: []
        ),
        .testTarget(
            name: "OtherAppsTests",
            dependencies: ["OtherApps"]
        ),
    ]
) 