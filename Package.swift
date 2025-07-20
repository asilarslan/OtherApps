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
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "OtherApps",
            targets: ["OtherApps"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // No external dependencies required - uses only native SwiftUI and Foundation
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "OtherApps",
            dependencies: [],
            path: "OtherApps",
            sources: [
                "Models.swift",
                "AppStoreService.swift", 
                "Views/AppCardView.swift",
                "Views/OtherAppsView.swift",
                "OtherApps.swift"
            ]
        ),
        .testTarget(
            name: "OtherAppsTests",
            dependencies: ["OtherApps"]),
    ]
) 