// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fallinlink-iOS",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "fallinlink-iOS",
            targets: ["fallinlink-iOS"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "fallinlink-iOS"),
        .testTarget(
            name: "fallinlink-iOSTests",
            dependencies: ["fallinlink-iOS"]),
    ]
)
