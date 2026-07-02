// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "LibboxLocal",
    platforms: [.iOS(.v15), .macOS(.v13), .tvOS(.v17)],
    products: [
        .library(name: "Libbox", targets: ["Libbox"]),
    ],
    targets: [
        .binaryTarget(
            name: "Libbox",
            path: "Libbox.xcframework"
        ),
    ]
)
