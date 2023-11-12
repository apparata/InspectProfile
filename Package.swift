// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "InspectProfile",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "inspro", targets: ["inspro"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.2.2"),
        .package(url: "https://github.com/apparata/SystemKit", exact: "1.5.0"),
        .package(url: "https://github.com/apparata/BinaryDataKit", exact: "1.0.3")
    ],
    targets: [
        .executableTarget(
            name: "inspro",
            dependencies: [
                "InspectProfile",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("SWIFT_PACKAGE")
            ]),
        .target(
            name: "InspectProfile",
            dependencies: [
                "SystemKit",
                "BinaryDataKit"
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("SWIFT_PACKAGE")
            ]),
    ]
)
