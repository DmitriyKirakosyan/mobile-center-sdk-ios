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
            checksum: "7d5cef21ed6eb69f753d302a593b9557c95509dd3e9c2d147dc29749c8d35f20"
        )
    ]
)
