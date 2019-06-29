// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "swift-termina",
    products: [
        .executable(
            name: "TerminaTests",
            targets: ["TerminaTests"]
        ),
        .library(
            name: "TerminaLib",
            targets: ["TerminaLib"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TerminaLib",
            dependencies: [],
            path: "src"
        ),
        .target(
            name: "TerminaTests",
            dependencies: ["TerminaLib"],
            path: "tests"
        ),
    ]
)
