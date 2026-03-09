// swift-tools-version:5.10

import Foundation
import PackageDescription

let environment = ProcessInfo.processInfo.environment

let treatWarningsAsErrors = environment["CI"] == "true"
let enableSwiftLintBuildToolPlugin = environment["CODEQL_DIST"] == nil

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
            url: "https://github.com/Tinder/Nodes.git",
            "0.0.0"..<"2.0.0"),
        .package(
            url: "https://github.com/socketio/socket.io-client-swift.git",
            exact: "16.1.1"),
        .package(
            url: "https://github.com/SimplyDanny/SwiftLintPlugins.git",
            exact: "0.59.1"),
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
            ]),
    ]
)

package.targets.forEach { target in

    let types: [Target.TargetType] = [
        .regular,
        .test,
        .executable,
        .macro,
    ]

    guard types.contains(target.type)
    else { return }

    target.swiftSettings = (target.swiftSettings ?? []) + [.enableExperimentalFeature("StrictConcurrency")]

//    if treatWarningsAsErrors {
//        target.swiftSettings = (target.swiftSettings ?? []) + [
//            .treatAllWarnings(as: .error),
//            .treatWarning("DeprecatedDeclaration", as: .warning),
//        ]
//    }

    if enableSwiftLintBuildToolPlugin {
        target.plugins = (target.plugins ?? []) + [
            .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
        ]
    }
}
