//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes-Tree-Visualizer/blob/main/LICENSE for license information.
//

#if DEBUG

extension String {

    internal func deletingSuffix(_ suffix: String) -> String {
        hasSuffix(suffix) ? String(dropLast(suffix.count)) : self
    }
}

#endif
