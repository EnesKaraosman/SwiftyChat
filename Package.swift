// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyChat",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftyChat",
            targets: ["SwiftyChat"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        
        // Image downloading library
        
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "1.5.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.8.0")
        
        // Introspecting underlying UIKit components
//        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftyChat",
            dependencies: [
                "SDWebImageSwiftUI", "SDWebImage"
            ]
        )
    ]
)
