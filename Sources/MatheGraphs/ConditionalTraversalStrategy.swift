//
//  ConditionalTraversalStrategy.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

public import Graphs

public struct ConditionalTraversalStrategy<Base: GraphTraversalStrategy> {
    // MARK: Variables
    public var base: Base
    public var earlyExit: (Base.Node) -> Bool

    // MARK: Initializers
    public init(
        _ base: Base,
        earlyExit: @escaping (Base.Node) -> Bool
    ) {
        self.base = base
        self.earlyExit = earlyExit
    }
}

// MARK: Self: GraphTraversalStrategy
extension ConditionalTraversalStrategy: GraphTraversalStrategy {
    public typealias Node = Base.Node
    public typealias Edge = Base.Edge
    public typealias Visit = Base.Visit
    public typealias Storage = Base.Storage

    public func initializeStorage(startNode: Base.Node) -> Base.Storage {
        base.initializeStorage(startNode: startNode)
    }

    public func node(from visit: Base.Visit) -> Base.Node {
        base.node(from: visit)
    }

    public func next(from storage: inout Base.Storage, edges: (Base.Node) -> some Sequence<Graphs.GraphEdge<Self.Node, Self.Edge>>) -> Base.Visit? {
        while let visit = base.next(
            from: &storage,
            edges: edges
        ) {
            let node = base.node(from: visit)

            if earlyExit(node) { continue }

            return visit
        }

        return nil
    }
}
