// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "device_info_plus",
    platforms: [
        .macOS("10.14")
    ],
    products: [
        .library(name: "device-info-plus", targets: ["device_info_plus"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "device_info_plus",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
