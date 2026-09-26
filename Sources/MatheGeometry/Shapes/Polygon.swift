//
//  Polygon.swift
//  Mathe
//
//  Created by Martônio Júnior on 07/05/2026.
//

public import MatheRange

/// Plane figure made up of line segments that connect together to form a closed chain.
public protocol Polygon {
    /// Storage containing all the lines that form a polygon.
    associatedtype Edges: Collection where Edges.Element == Extent<Vertices.Element>
    /// Storage containing all the points that compose this polygon.
    associatedtype Vertices: Collection
    /// Edges of this polygon.
    var edges: Edges { get }
    /// Vertices of the polygon.
    var vertices: Vertices { get }
}

// MARK: Shape (EX)
public extension Polygon where Self: Shape {
    /// Polygons are, by definition, closed chains.
    /// 
    /// Therefore, this property always returns `true`
    var isClosed: Bool { true }
}
