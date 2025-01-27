// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "Nodes-Tree-Visualizer",
    platforms: [
        .iOS(.v13),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "NodesSocketIO",
            targets: ["NodesSocketIO"]),
    ],
    dependencies: [
        .package(
            url: "git@github.com:Tinder/Nodes.git",
            "0.0.0"..<"2.0.0"),
        .package(
            url: "https://github.com/socketio/socket.io-client-swift.git",
            exact: "16.1.1"),
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            exact: "0.56.2"),
        .package(
            url: "https://github.com/Quick/Nimble.git",
            exact: "13.4.0"),
    ],
    targets: [
        .target(
            name: "NodesSocketIO",
            dependencies: [
                "Nodes",
                .product(name: "SocketIO", package: "socket.io-client-swift"),
            ]),
        .testTarget(
            name: "NodesSocketIOTests",
            dependencies: [
                "NodesSocketIO",
                "Nimble",
            ]),
    ]
)

package.targets.forEach { target in

    target.swiftSettings = [
        .enableExperimentalFeature("StrictConcurrency"),
    ]

    target.plugins = [
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint"),
    ]
}
