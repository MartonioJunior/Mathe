//
//  Path+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

public import Graphs
public import NonEmpty

public extension Path {
    var reversed: Self {
        .init(source: destination, destination: source, edges: edges.map(\.reversed).reversed())
    }

    /// Adds a connection to a new node
    func connecting(_ nodes: some Sequence<Node>, using edge: Edge) -> Self {
        var destination = destination
        var extraEdges = [GraphEdge<Node, Edge>]()

        for node in nodes {
            extraEdges.append(GraphEdge(source: destination, destination: node, value: edge))
            destination = node
        }

        return .init(source: source, destination: destination, edges: edges + extraEdges)
    }
    /// Removes the first node from the collection
    func disconnectingFirst() -> Self? {
        var edges = edges

        if edges.isEmpty { return nil }

        let removedEdge = edges.removeFirst()

        return .init(source: source, destination: removedEdge.source, edges: edges)
    }
    /// Removes the end node from the collection
    func disconnectingLast() -> Self? {
        var edges = edges

        guard let removedEdge = edges.popLast() else { return nil }

        return .init(source: source, destination: removedEdge.source, edges: edges)
    }

    func allSpacesSatisfy(where predicate: (Node) -> Bool) -> Bool {
        predicate(source)
        && edges.allSatisfy { predicate($0.source) && predicate($0.destination) }
        && predicate(destination)
    }

    func allEdgesSatisfy(where predicate: (GraphEdge<Node, Edge>) -> Bool) -> Bool {
        edges.allSatisfy(predicate)
    }
}

// MARK: DotSyntax
public extension Path {
    static func closed(
        _ nodes: NonEmptyArray<Node>,
        edge: (Node, Node) -> Edge
    ) -> Self {
        compose(source: nodes.first, inBetweens: nodes.dropFirst(), destination: nodes.first, edge: edge)
    }

    static func compose(
        source: Node,
        inBetweens: some Sequence<Node>,
        destination: Node,
        edge: (Node, Node) -> Edge
    ) -> Self {
        var edges: [GraphEdge<Node, Edge>] = []
        var origin = source
        for node in inBetweens + [destination] {
            edges.append(GraphEdge(source: origin, destination: node, value: edge(origin, node)))
            origin = node
        }

        return .init(source: source, destination: destination, edges: edges)
    }

    static func disconnected(source: Node, destination: Node) -> Self {
        .init(source: source, destination: destination, edges: [])
    }

    static func open(
        _ nodes: NonEmpty<NonEmptyArray<Node>>,
        edge: (Node, Node) -> Edge
    ) -> Self {
        compose(source: nodes.first, inBetweens: nodes.dropLast().dropFirst(), destination: nodes.last, edge: edge)
    }

    static func point(_ node: Node) -> Self {
        .disconnected(source: node, destination: node)
    }
}

// MARK: Edge == Empty
public extension Path where Edge == Empty {
    func connecting(_ nodes: some Sequence<Node>) -> Self {
        connecting(nodes, using: Empty())
    }
}

// MARK: Node: Equatable
public extension Path where Node: Equatable {
    var isClosed: Bool { source == destination }

    func skip(_ node: Node) -> Self? {
        switch node {
            case source:
                return disconnectingFirst()
            case destination:
                return disconnectingLast()
            default:
                var edges = edges
                edges.removeAll { $0.source == node || $0.destination == node }
                return .init(source: source, destination: destination, edges: edges)
        }
    }

    func skipMany(_ nodes: some Sequence<Node>) -> Self? {
        let result: Self? = self
        return nodes.reduce(result) {
            $0?.skip($1)
        }
    }
}

// MARK: Self.Node: Hashable
public extension Path where Node: Hashable, Edge == Empty {
    static func reconstructedBackwards(
        _ searchTable: [Node: Node],
        from start: Node,
        to destination: Node
    ) -> Self? {
        guard searchTable.keys.contains(destination) else { return nil }

        var edges: [GraphEdge<Node, Edge>] = []
        var current = destination

        while current != start {
            guard let previous = searchTable[current] else { return nil }

            edges.append(GraphEdge(source: current, destination: previous))

            current = previous
        }

        return .init(source: start, destination: destination, edges: edges)
    }
}

// MARK: Sequence (EX)
public extension Sequence {
    func paths<Node, Edge>(
        startingOn start: @escaping (Node) -> Bool
    ) -> [Element] where Element == Path<Node, Edge> {
        filter {
            start($0.source)
        }
    }

    func paths<Node, Edge>(
        endingOn end: @escaping (Node) -> Bool
    ) -> [Element] where Element ==Path<Node, Edge> {
        filter {
            end($0.destination)
        }
    }
}
