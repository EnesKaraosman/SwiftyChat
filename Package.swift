// swift-tools-version:6.0
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
        // Kingfisher 8.13 requires Swift 6.2; keep Swift 6.0 support.
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMinor(from: "8.13.0"))
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
