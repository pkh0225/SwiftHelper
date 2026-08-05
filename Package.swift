// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftHelper",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SwiftHelper",
            targets: ["SwiftHelper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
        .package(url: "https://github.com/InderKumarRathore/DeviceGuru.git", from: "10.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftHelper",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
                .product(name: "DeviceGuru", package: "DeviceGuru"),
            ])
    ]
)
