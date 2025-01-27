//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes-Tree-Visualizer/blob/main/LICENSE for license information.
//

#if DEBUG

import Combine
import Foundation
@preconcurrency import Nodes
@preconcurrency import SocketIO

public class DebugSocket<T> where T: AnyObject, T: Sendable {

    private var socket: SocketIOClient {
        socketManager.defaultSocket
    }

    private let socketManager: SocketManager

    private let debugInformation: AnyPublisher<DebugInformation, Never> = DebugInformation.publisher()
    private var factories: [String: DebugInformation.Factory] = [:]

    private var allNodes: [String: Node] = [:]

    private var rootNodes: [Node] = [] {
        didSet { emitTree() }
    }

    private let encoder: JSONEncoder = .init()

    private var cancellables: Set<AnyCancellable> = .init()

    public convenience init(
        transform: @escaping @Sendable @MainActor (T) throws -> Data?
    ) {
        // swiftlint:disable:next force_unwrapping
        self.init(url: "http://localhost:3000", transform: transform)!
    }

    public init?(
        url: String,
        transform: @escaping @Sendable @MainActor (T) throws -> Data?
    ) {
        guard let url: URL = .init(string: url)
        else { return nil }
        socketManager = SocketManager(socketURL: url, config: [.compress, .log(false)])
        handleSocketEvents(transform: transform)
    }

    public func connect() {
        guard socket.status == .notConnected || socket.status == .disconnected
        else { return }
        socket.connect()
        guard cancellables.isEmpty
        else { return }
        debugInformation
            .sink { [weak self] debugInformation in
                guard let self
                else { return }
                process(debugInformation: debugInformation)
            }
            .store(in: &cancellables)
    }

    private func emitTree() {
        do {
            let data: Data = try encoder.encode(rootNodes)
            let json: String = .init(decoding: data, as: UTF8.self)
            socket
                .emitWithAck("tree", json)
                .timingOut(after: 1) { _ in }
        } catch {}
    }

    private func handleSocketEvents(
        transform: @escaping @Sendable @MainActor (T) throws -> Data?
    ) {
        socket.on(clientEvent: .connect) { [weak self] _, _ in
            guard let self
            else { return }
            emitTree()
            for id: String in factories.keys {
                socket
                    .emitWithAck("factory", id)
                    .timingOut(after: 1) { _ in }
            }
        }
        socket.on("image") { [weak self] data, ack in
            guard let self,
                  let id: String = data.first as? String,
                  let factory: DebugInformation.Factory = factories[id]
            else { return }
            Task { @MainActor in
                do {
                    let data: Data?? = try await factory.make(withObjectOfType: T.self, transform: transform)
                    guard let data: Data?,
                          let data: Data
                    else { return }
                    ack.with(data)
                } catch {}
            }
        }
    }

    private func process(debugInformation: DebugInformation) {
        switch debugInformation {
        case let .flowWillStart(flowIdentifier, flowType, factory):
            validate(factory: factory, for: Node(identifier: flowIdentifier, type: flowType))
        case .flowDidEnd:
            break
        case let .flowWillAttachSubFlow(flowIdentifier, flowType, subFlowIdentifier, subFlowType):
            let parent: Node = .init(identifier: flowIdentifier, type: flowType)
            attach(Node(parent: parent, identifier: subFlowIdentifier, type: subFlowType))
        case let .flowDidDetachSubFlow(_, _, subFlowIdentifier, subFlowType):
            detach(Node(identifier: subFlowIdentifier, type: subFlowType))
        case let .flowControllerWillAttachFlow(_, flowIdentifier, flowType):
            attach(Node(identifier: flowIdentifier, type: flowType))
        case let .flowControllerDidDetachFlow(_, flowIdentifier, flowType):
            detach(Node(identifier: flowIdentifier, type: flowType))
        }
    }

    private func validate(factory: DebugInformation.Factory, for node: Node) {
        guard factory.canMake(withObjectOfType: T.self)
        else { return }
        factories[node.id] = factory
        socket
            .emitWithAck("factory", node.id)
            .timingOut(after: 1) { _ in }
    }

    private func attach(_ child: Node) {
        guard allNodes[child.id] == nil
        else { return }
        allNodes[child.id] = child
        if let parent: Node = child.parent {
            if let existingParent: Node = allNodes[parent.id] {
                child.parent = existingParent
            } else {
                allNodes[parent.id] = parent
            }
        }
        child.parent?.children.append(child)
        updateRootNodes()
    }

    private func detach(_ child: Node) {
        guard let child: Node = allNodes[child.id]
        else { return }
        allNodes[child.id] = nil
        child.parent?.children.removeAll { $0 === child }
        updateRootNodes()
    }

    private func updateRootNodes() {
        rootNodes = allNodes
            .values
            .filter { $0.parent == nil }
            .sorted { $0.name < $1.name }
    }
}

#endif
