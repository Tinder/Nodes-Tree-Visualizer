//
//  Copyright © 2025 Tinder (Match Group, LLC)
//

import Nimble
import NodesSocketIO
import XCTest

final class NodesSocketIOTests: XCTestCase {

    func testDebugSocket() {
        expect(DebugSocket()) != nil
    }
}
