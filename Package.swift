// swift-tools-version:5.3

// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

import PackageDescription

let package = Package(
    name: "AppCenter",
    defaultLocalization: "en",
    products: [
        .library(name: "AppCenter", targets: ["AppCenter"]),
        .library(name: "AppCenterAnalytics", targets: ["AppCenterAnalytics"]),
        .library(name: "AppCenterCrashes", targets: ["AppCenterCrashes"]),
        .library(name: "AppCenterDistribute", targets: ["AppCenterDistribute", "AppCenterDistributeResources"])
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "AppCenter",
            url: "https://github.com/DmitriyKirakosyan/mobile-center-sdk-ios/releases/download/v1.0/AppCenter.xcframework.zip",
            checksum: "3f0094463c8f1f10823f8245a8fed459e788019cb8fdc45576d096a37e2e348d"
        ),
        .binaryTarget(
            name: "AppCenterAnalytics",
            url: "https://github.com/DmitriyKirakosyan/mobile-center-sdk-ios/releases/download/v1.0/AppCenterAnalytics.xcframework.zip",
            checksum: "966e72ad06da674e06621ddc34993e30c462c26022c4b632ad9631aab09f422c"
        ),
        .binaryTarget(
            name: "AppCenterCrashes",
            url: "https://github.com/DmitriyKirakosyan/mobile-center-sdk-ios/releases/download/v1.0/AppCenterCrashes.xcframework.zip",
            checksum: "2c20964d5f63ac1ddff64b7cca5b14620ebcc2f95900fa34a6ed01b4a73b8817"
        ),
        .binaryTarget(
            name: "AppCenterDistribute",
            url: "https://github.com/DmitriyKirakosyan/mobile-center-sdk-ios/releases/download/v1.0/AppCenterDistribute.xcframework.zip",
            checksum: "9a4e8669e7340c3bb6d6d9bd1efa60aee49d455bfc288ea6112a6a4b88a7f0c7"
        ),
        .target(
            name: "AppCenterDistributeResources",
            path: "AppCenterDistribute/AppCenterDistribute",
            exclude: ["Support"],
            resources: [
                .process("Resources/AppCenterDistribute.strings"),
            ]
        )
    ]
)
