//
//  Shape.swift
//  Mathe
//
//  Created by Martônio Júnior on 02/12/2025.
//

/// Representation of a geometric figure of any dimension.
public protocol Shape: Geometric {
    /// Type representing the interpolation parameter used to retrieve a point in the shape's outline.
    associatedtype OutlineParameter
    /// Is it a closed shape?
    /// 
    /// A closed shape assumes that the end point connects back to the start.
    var isClosed: Bool { get }
    /// Indicates whether a point is part of the shape's border.
    /// - Parameter point: Point in the coordinate space.
    /// Returns: `true` when the point is part of the outline, `false` otherwise.
    func isOutline(for point: Coordinate) -> Bool
    /// Defines a position in the shape's outline based on a parameter `t`.
    /// - Parameter t: Parameter for the interpolation.
    /// - Returns: Point guaranteed to be part of the outline.
    func outline(t: OutlineParameter) -> Coordinate
}

// MARK: Default Implementation
public extension Shape {
    // swiftlint:disable:next missing_docs
    var isClosed: Bool { true }
}

// MARK: Self.OutlineParameter == Never
public extension Shape where OutlineParameter == Never {
    /// Defines a position in the shape's outline based on a parameter `t`.
    /// - Parameter t: Parameter for the interpolation.
    /// - Returns: Point guaranteed to be part of the outline.
    func outline(t _: Never) -> Coordinate {}
}
