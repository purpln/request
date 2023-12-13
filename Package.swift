// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "request",
    products: [
        .library(name: "Request", targets: ["Request"]),
    ],
    dependencies: [
        .package(url: "https://github.com/purpln/link.git", branch: "main")
    ],
    targets: [
        .target(name: "Request", dependencies: [.product(name: "Link", package: "Link")])
    ]
)
#if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
package.platforms = [.iOS(.v13), .macOS(.v10_15), .macCatalyst(.v13)]
#endif
