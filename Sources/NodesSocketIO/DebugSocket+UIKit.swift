//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes-Tree-Visualizer/blob/main/LICENSE for license information.
//

#if DEBUG && canImport(UIKit)

import UIKit

extension DebugSocket where T: UIViewController {

    public convenience init(
        jpegCompressionQuality compressionQuality: CGFloat = DebugSocketConstants.jpegCompressionDefaultQuality
    ) {
        // swiftlint:disable:next force_unwrapping
        self.init(url: "http://localhost:3000", jpegCompressionQuality: compressionQuality)!
    }

    public convenience init?(
        url: String,
        jpegCompressionQuality compressionQuality: CGFloat = DebugSocketConstants.jpegCompressionDefaultQuality
    ) {
        self.init(url: url) { viewController in
            let view: UIView = viewController.view
            let renderer: UIGraphicsImageRenderer = .init(bounds: view.bounds)
            let image: UIImage = renderer.image { view.layer.render(in: $0.cgContext) }
            return image.jpegData(compressionQuality: compressionQuality)
        }
    }
}

#endif
