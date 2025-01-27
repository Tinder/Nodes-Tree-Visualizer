//
//  Copyright © 2024 Tinder (Match Group, LLC)
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
