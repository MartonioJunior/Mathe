//
//  Graph+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 22/02/26.
//

public extension EdgeMutableGraph {
    /// Adds a connection to a new node
    mutating func connect(
        _ vertices: some Sequence<VertexDescriptor>,
        to originVertex: VertexDescriptor
    ) {
        for vertex in vertices {
            addEdge(from: originVertex, to: vertex)
        }
    }
}

public extension EdgeMutablePropertyGraph {
    /// Adds a connection to a new node
    mutating func connect(
        _ vertices: some Sequence<VertexDescriptor>,
        to originVertex: VertexDescriptor,
        configure: @escaping (inout EdgePropertyMap.Value) -> Void
    ) {
        for vertex in vertices {
            addEdge(from: originVertex, to: vertex, configure: configure)
        }
    }
}
