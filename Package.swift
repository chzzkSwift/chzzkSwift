// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "chzzkSwift",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "chzzkSwift",
            targets: ["chzzkSwift"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.1"),
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.6"),
    ],

    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "chzzkSwift",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Starscream", package: "Starscream"),
            ]
        ),
        .testTarget(
            name: "chzzkSwiftTests",
            dependencies: ["chzzkSwift", "Alamofire", "Starscream"]
        ),
    ]
)
