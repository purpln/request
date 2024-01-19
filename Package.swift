// swift-tools-version:5.8

import PackageDescription
#if os(Linux)
let packages: [Package.Dependency] = [
    .package(url: "https://github.com/purpln/link.git", branch: "main"),
    .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.20.0")
]
let dependencies: [Target.Dependency] = [
    .product(name: "Link", package: "Link"),
    .product(name: "AsyncHTTPClient", package: "async-http-client")
]
#else
let packages: [Package.Dependency] = [
    .package(url: "https://github.com/purpln/link.git", branch: "main")
]
let dependencies: [Target.Dependency] = [
    .product(name: "Link", package: "Link")
]
#endif

let package = Package(
    name: "request",
    products: [
        .library(name: "Request", targets: ["Request"]),
    ],
    dependencies: packages,
    targets: [
        .target(name: "Request", dependencies: dependencies)
    ]
)
#if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
package.platforms = [.iOS(.v13), .macOS(.v10_15), .macCatalyst(.v13)]
#endif
