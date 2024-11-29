# Nodes Tree Visualizer

A Swift library and companion web application for tree visualization of apps that use the [Nodes Architecture Framework](https://github.com/Tinder/Nodes) for _Native Mobile Application Engineering at Scale_

## Web Application

### Dependencies

```
brew install node
```

### Server

```
git clone git@github.com:TinderApp/Nodes-Tree-Visualizer.git
cd Nodes-Tree-Visualizer
make serve
```

### Website

```
open http://localhost:3000
```

## Swift Library

### Dependency

> Replace `<version>` with the desired minimum version.

```swift
.package(url: "https://github.com/TinderApp/Nodes-Tree-Visualizer.git", from: "<version>")
```

### Connect

```swift
import NodesSocketIO
```

```swift
#if DEBUG
private let debugSocket: DebugSocket<UIViewController> = .init()
#endif
```

```swift
#if DEBUG
debugSocket.connect()
#endif
```

The following example demonstrates how to setup a Nodes [Quick Start](https://github.com/Tinder/Nodes#quick-start) project for example:

```swift

import NodesSocketIO
import UIKit

@main
internal final class AppDelegate: UIResponder, UIApplicationDelegate {

    ...

    #if DEBUG
    private let debugSocket: DebugSocket<UIViewController> = .init()
    #endif

    ...

    internal func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        #if DEBUG
        debugSocket.connect()
        #endif
        ...
        return true
    }

    ...
}
```

### Custom Rendering

For non-UIKit apps or to customize the view rendering, provide a closure to the `DebugSocket` initializer.

```swift
let debugSocket: DebugSocket<UIViewController> = .init { viewController in
    let view: UIView = viewController.view
    let renderer: UIGraphicsImageRenderer = .init(bounds: view.bounds)
    let image: UIImage = renderer.image { view.layer.render(in: $0.cgContext) }
    return image.jpegData(compressionQuality: compressionQuality)
}
```
