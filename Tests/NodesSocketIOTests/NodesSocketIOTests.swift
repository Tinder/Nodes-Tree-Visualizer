//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes-Tree-Visualizer/blob/main/LICENSE for license information.
//

import NodesSocketIO
import Testing

struct NodesSocketIOTests {

    private final class Mock: Sendable {}

    @Test
    func testDebugSocket() {
        let debugSocket: DebugSocket<Mock>? = .init { _ in nil }
        #expect(debugSocket != nil)
    }
}
