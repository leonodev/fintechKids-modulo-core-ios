// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FHKCore",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "FHKCore",
            targets: ["FHKCore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/leonodev/fintechKids-modulo-domain-ios.git",
                branch: "main")
        ],
    targets: [
        .target(
            name: "FHKCore",
            dependencies: [
                // Modules FHK
                .product(name: "FHKDomain", package: "fintechKids-modulo-domain-ios")
            ],
            resources: [
                .process("Resources/Urls"),
            ]
        ),
        .testTarget(
            name: "FHKCoreTests",
            dependencies: ["FHKCore"]
        ),
    ]
)
