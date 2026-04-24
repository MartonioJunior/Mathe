//
//  Path+NonEmpty.swift
//  Mathe
//
//  Created by Martônio Júnior on 23/04/2026.
//

#if NonEmpty
public import NonEmpty

public extension Path {
    init(vertices: NonEmptyArray<Vertex>, edges: [Edge]) {
        self.init(source: vertices.first, destination: vertices.last, vertices: vertices.map(\.self), edges: edges)
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

    static func disconnected(source: Vertex, destination: Vertex) -> Self {
        .init(vertices: [source, destination], edges: [])
    }

    static func open(
        _ nodes: NonEmpty<NonEmptyArray<Vertex>>,
        makeEdge: (Vertex, Vertex) -> Edge
    ) -> Self {
        compose(source: nodes.first, inBetweens: nodes.dropLast().dropFirst(), destination: nodes.last, makeEdge: makeEdge)
    }
}
#endif
