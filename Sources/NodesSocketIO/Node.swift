//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes-Tree-Visualizer/blob/main/LICENSE for license information.
//

#if DEBUG

internal class Node: Encodable {

    private enum CodingKeys: CodingKey {

        case id, name, children
    }

    internal weak var parent: Node?

    internal let id: String
    internal let name: String

    internal var children: [Node] = []

    internal convenience init(
        identifier: ObjectIdentifier,
        type: Any.Type
    ) {
        self.init(parent: nil, id: UInt(bitPattern: identifier), type: type)
    }

    internal convenience init(
        parent: Node,
        identifier: ObjectIdentifier,
        type: Any.Type
    ) {
        self.init(parent: parent, id: UInt(bitPattern: identifier), type: type)
    }

    private init(
        parent: Node?,
        id: UInt,
        type: Any.Type
    ) {
        self.parent = parent
        self.id = String(id)
        self.name = "\(type)".deletingSuffix("Imp").deletingSuffix("Flow")
    }

    internal func recursiveDescription(level: Int = 0) -> String {
        let prefix: String = .init(repeating: "  ", count: level) + "- "
        guard !children.isEmpty
        else { return "\(prefix)\(name)" }
        let children: String = children
            .map { $0.recursiveDescription(level: level + 1) }
            .joined(separator: "\n")
        return "\(prefix)\(name)\n\(children)"
    }
}

#endif
