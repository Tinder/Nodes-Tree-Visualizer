// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Nodes-Tree-Visualizer",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "NodesSocketIO",
            targets: ["NodesSocketIO"]),
    ],
    dependencies: [
        .package(
            url: "git@github.com:Tinder/Nodes.git",
            from: "0.0.0"),
        .package(
            url: "https://github.com/socketio/socket.io-client-swift.git",
            from: "16.1.0"),
    ],
    targets: [
        .target(
            name: "NodesSocketIO",
            dependencies: [
                "Nodes",
                .product(name: "SocketIO", package: "socket.io-client-swift"),
            ]),
    ]
)
