// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InvoiceKit",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "InvoiceKit",
            targets: ["InvoiceKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "InvoiceKit",
            dependencies: []),
        .testTarget(
            name: "InvoiceKitTests",
            dependencies: ["InvoiceKit"]),
        .binaryTarget(
              name: "InvoiceKit",
              url: "https://github.com/PrajeetShrestha/InvoiceKit/blob/main/InvoiceKit.xcframework.zip",
              checksum: "fd5936644bcd96eb1fde4d29bc284f248a195086a0688fa16a6da9be1d822273"
          ),
    ]
)
