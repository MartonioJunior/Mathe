//
//  Shape.swift
//  Mathe
//
//  Created by Martônio Júnior on 02/12/2025.
//

public import MatheCoordinates

/// Representation of a geometric figure of any dimension.
public protocol Shape: Geometric {
    /// Is it a closed shape?
    /// 
    /// A closed shape assumes that the end point connects back to the start.
    var isClosed: Bool { get }
    /// Function that returns the distance of a point to the shape's border.
    /// - Parameter point: Point in the coordinate space.
    /// 
    /// Returns:
    /// - A negative value when the coordinate is contained within the shape.
    /// - Zero when the coordinate is tangent to the shape.
    /// - A positive value when is not part of the shape.
    func distanceFromBorder(for point: Coordinate) -> Coordinate.Scalar
}

// MARK: Self.Coordinate.Scalar: Comparable
public extension Shape where Coordinate.Scalar: Comparable {
    /// Checks whether a point is inside or outside of the shape.
    /// - Parameter point: Coordinate to compare.
    /// - Returns: `.inside` when point is part of the shape, `.outside` when it's not.
    func comparePoint(_ point: Coordinate) -> OverlapScore {
        distanceFromBorder(for: point) > .zero ? .outside : .inside
    }
}
