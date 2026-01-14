// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyChat",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftyChat",
            targets: ["SwiftyChat"]
        ),
        .library(
            name: "SwiftyChatMock",
            targets: ["SwiftyChatMock"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.6.2"),
        .package(url: "https://github.com/EnesKaraosman/SwiftUIEKtensions.git", from: "0.4.0"),
        .package(url: "https://github.com/dkk/WrappingHStack.git", from: "2.2.11")
    ],
    targets: [
        .target(
            name: "SwiftyChat",
            dependencies: [
                .byName(name: "Kingfisher"),
                .byName(name: "SwiftUIEKtensions"),
                .byName(name: "WrappingHStack")
                
            ],
            exclude: ["Demo/Preview"]
        ),
        .target(
            name: "SwiftyChatMock",
            dependencies: [
                "SwiftyChat"
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
