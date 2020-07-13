// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-log-papertrail",
    products: [
        .library(
            name: "PapertrailLogHandler",
            targets: ["PapertrailLogHandler"])
    ],
    dependencies: [
      .package(url: "https://github.com/apple/swift-log.git", .upToNextMajor(from: "1.0.0")),
      .package(url: "https://github.com/robbiehanson/CocoaAsyncSocket.git", from: "7.6.4")
    ],
    targets: [
        .target(
            name: "PapertrailLogHandler",
            dependencies: [ "Logging", "CocoaAsyncSocket" ])
    ]
)
