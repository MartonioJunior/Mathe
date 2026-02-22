//
//  Path+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

public import NonEmpty

public extension Path {
    var reversed: Self {
        .init(source: destination, destination: source, vertices: vertices.reversed(), edges: edges.reversed())
    }
    
    init(vertices: NonEmptyArray<Vertex>, edges: [Edge]) {
        self.init(source: vertices.first, destination: vertices.last, vertices: vertices.map(\.self), edges: edges)
    }

    /// Adds a connection to a new node
    func connecting(
        _ vertices: some Sequence<Vertex>,
        makeEdge: (Vertex, Vertex) -> Edge
    ) -> Self {
        var lastVertex = destination
        var extraVertices = [Vertex]()
        var extraEdges = [Edge]()

        for vertex in vertices {
            extraVertices.append(vertex)
            extraEdges.append(makeEdge(lastVertex, vertex))
            lastVertex = vertex
        }

        return .init(source: source, destination: destination, vertices: vertices + extraVertices, edges: edges + extraEdges)
    }

    /// Removes the first node from the collection
    func disconnectingFirst() -> Self? {
        guard let newSource = vertices.dropFirst().first else { return nil }

        return .init(source: newSource, destination: destination, vertices: Array(vertices.dropFirst()), edges: Array(edges.dropFirst()))
    }

    /// Removes the end node from the collection
    func disconnectingLast() -> Self? {
        guard let newDestination = vertices.dropLast().last else { return nil }

        return .init(source: source, destination: newDestination, vertices: Array(vertices.dropLast()), edges: Array(edges.dropLast()))
    }
}

// MARK: DotSyntax
public extension Path {
    static func closed(
        _ nodes: NonEmptyArray<Vertex>,
        makeEdge: (Vertex, Vertex) -> Edge
    ) -> Self {
        compose(source: nodes.first, inBetweens: nodes.dropFirst(), destination: nodes.first, makeEdge: makeEdge)
    }

    static func compose(
        source: Vertex,
        inBetweens: some Sequence<Vertex>,
        destination: Vertex,
        makeEdge: (Vertex, Vertex) -> Edge
    ) -> Self {
        var edges: [Edge] = []
        var vertices: [Vertex] = [source]

        var origin = source

        for node in inBetweens + [destination] {
            vertices.append(node)
            edges.append(makeEdge(origin, node))
            origin = node
        }

        return .init(source: source, destination: destination, vertices: vertices, edges: edges)
    }

    static func disconnected(source: Vertex, destination: Vertex) -> Self {
        .init(vertices: [source, destination], edges: [])
    }

    static func open(
        _ nodes: NonEmpty<NonEmptyArray<Vertex>>,
        makeEdge: (Vertex, Vertex) -> Edge
    ) -> Self {
        compose(source: nodes.first, inBetweens: nodes.dropLast().dropFirst(), destination: nodes.last, makeEdge: makeEdge)
    }

    static func point(_ node: Vertex) -> Self {
        .disconnected(source: node, destination: node)
    }
}

// MARK: Node: Equatable
public extension Path where Vertex: Equatable {
    var isClosed: Bool { source == destination }

    func skip(_ vertex: Vertex) -> Self? {
        switch vertex {
            case source:
                return disconnectingFirst()
            case destination:
                return disconnectingLast()
            default:
                guard let index = vertices.firstIndex(of: vertex) else { return nil }
                var vertices = vertices
                var edges = edges
                vertices.remove(at: index)
                edges.remove(at: index)
                edges.remove(at: edges.index(before: index))
                return .init(source: source, destination: destination, vertices: vertices, edges: edges)
        }
    }

    func skipMany(_ vertex: some Sequence<Vertex>) -> Self? {
        let result: Self? = self
        return vertex.reduce(result) {
            $0?.skip($1)
        }
    }
}

// MARK: Self.Node: Hashable
public extension Path where Vertex: Hashable {
    static func reconstructedBackwards(
        _ searchTable: [Vertex: Vertex],
        from start: Vertex,
        to destination: Vertex,
        makeEdge: (Vertex, Vertex) -> Edge
    ) -> Self? {
        guard searchTable.keys.contains(destination) else { return nil }

        var edges: [Edge] = []
        var vertices: [Vertex] = [destination]
        var current = destination

        while current != start {
            guard let previous = searchTable[current] else { return nil }

            edges.append(makeEdge(current, previous))
            vertices.append(previous)

            current = previous
        }

        return .init(source: start, destination: destination, vertices: vertices, edges: edges)
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
