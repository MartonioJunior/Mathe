//
//  Polyhedron.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/05/2026.
//

public protocol Polyhedron: Geometric {
    associatedtype Faces: Collection where Faces.Element: Polygon

    var faces: Faces { get }
}

// MARK: Shape (EX)
public extension Polyhedron where Self: Shape {
    /// Polygons are, by definition, closed chains.
    /// 
    /// Therefore, this property always returns `true`
    var isClosed: Bool { true }
}
