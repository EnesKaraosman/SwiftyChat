// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyChat",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SwiftyChat",
            targets: ["SwiftyChat"]),
    ],
    dependencies: [
        // Image downloading library
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.8.1"),
        .package(url: "https://github.com/EnesKaraosman/SwiftUIEKtensions.git", from: "0.1.8"),
        .package(url: "https://github.com/wxxsw/VideoPlayer.git", from: "1.2.3"),
        .package(url: "https://github.com/dkk/WrappingHStack.git", from: "2.2.10")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftyChat",
            dependencies: [
                .byName(name: "Kingfisher"),
                .byName(name: "SwiftUIEKtensions"),
                .byName(name: "VideoPlayer"),
                .byName(name: "WrappingHStack")
                
            ],
            exclude: ["Demo/Preview"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
