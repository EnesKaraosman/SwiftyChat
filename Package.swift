// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyChat",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
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
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMinor(from: "8.14.0"))
    ],
    targets: [
        .target(
            name: "SwiftyChat",
            dependencies: [
                .byName(name: "Kingfisher")
                
            ]
        ),
        .target(
            name: "SwiftyChatMock",
            dependencies: [
                "SwiftyChat"
            ]
        ),
        .testTarget(
            name: "SwiftyChatTests",
            dependencies: ["SwiftyChat", "SwiftyChatMock"]
        )
    ],
    swiftLanguageModes: [.v6]
)
