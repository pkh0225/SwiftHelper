// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftHelper",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftHelper",
            targets: ["SwiftHelper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jaejinmanse/Nuke", from: "9.1.3"),
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.3.0"),
        .package(url: "https://github.com/pkh0225/EasyConstraints", from: "0.1.5")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftHelper",
            dependencies: ["Nuke", "Alamofire", "EasyConstraints"]),
    ]
)
