// swift-tools-version:5.3

// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

import PackageDescription

let package = Package(
    name: "AppCenter",
    products: [
        .library(name: "AppCenter", targets: ["AppCenter"])
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "AppCenter",
            url: "https://github.com/microsoft/appcenter-sdk-apple/releases/download/4.1.1/AppCenter-SDK-Apple-XCFramework-4.1.1.zip",
            checksum: "3dd421f36c1b423d4637d854cbcfb973104c1cb3148419dd142bdadff5362682"
        )
    ]
)
