// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TwilioLambda",
    platforms: [
      .macOS(.v12),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
      .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", branch: "main"),
      .package(url: "https://github.com/swift-server/swift-aws-lambda-events.git", branch: "main"),
      .package(url: "https://github.com/swift-server/async-http-client.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "TwilioLambda",
            dependencies: [
              .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
              .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
              .product(name: "AsyncHTTPClient", package: "async-http-client")
            ])
    ]
)
