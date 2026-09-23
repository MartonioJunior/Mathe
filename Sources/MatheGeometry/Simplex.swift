//
//  Simplex.swift
//  Mathe
//
//  Created by Martônio Júnior on 09/05/2026.
//

public import MatheRange
public import MatheSIMD

/// Alias for a triangle.
@available(macOS 26.0.0, *)
public typealias Triangle<Vertex> = Simplex<2, Vertex>
/// Alias for a tetrahedron.
@available(macOS 26.0.0, *)
public typealias Tetrahedron<Vertex> = Simplex<3, Vertex>
/// Generalization of a triangle for any number of dimensions.
@available(macOS 26.0.0, *)
public struct Simplex<let n: Int, Vertex> {
    // MARK: Variables
    /// Parameters used to define the triangle.
    var base: Vector<n, Vertex>
    /// Value required to create the simplest possible triangle equivalent in D dimensions.
    var end: Vertex
    // MARK: Initializers
    /// Creates a new simplex.
    /// - Parameters:
    ///   - base: Initial vertices.
    ///   - end: Final vertex.
    ///
    public init(_ base: Vector<n, Vertex>, end: Vertex) {
        self.base = base
        self.end = end
    }
}

// MARK: Self: Polygon
@available(macOS 26.0.0, *)
extension Simplex: Polygon {
    // swiftlint:disable:next missing_docs
    public typealias Edges = [Extent<Vertex>]
    // swiftlint:disable:next missing_docs
    public typealias Vertices = [Vertex]
    // swiftlint:disable:next missing_docs
    public var edges: Edges {
        vertices.enumerated().flatMap { entry in
            ((entry.offset + 1)...(n)).map { index in
                Extent(from: entry.element, to: vertices[index])
            }
        }
    }
    // swiftlint:disable:next missing_docs
    public var vertices: Vertices { Array(base) + [end] }
}
