//
//  LineSegment.swift
//  Mathe
//
//  Created by Martônio Júnior on 06/05/2026.
//

public import MatheCoordinates
public import MatheRange
public import MatheSIMD

/// Data structure that represents a line segment, delimited by two points.
@available(macOS 26.0.0, *)
public struct LineSegment<let n: Int, Scalar: AdditiveArithmetic> {
    // MARK: Variables
    /// Initial point for the line.
    public var start: CartesianCoordinate<n, Scalar>
    /// Final point for the line.
    public var end: CartesianCoordinate<n, Scalar>
    /// Line that has start and end points swapped around.
    var flipped: Self { .init(end, to: start) }
    // MARK: Initializers
    /// Creates a new line segment based on two points.
    /// - Parameters:
    ///   - start: Initial point for the line.
    ///   - end: Final point for the line.
    ///
    public init(_ start: CartesianCoordinate<n, Scalar>, to end: CartesianCoordinate<n, Scalar>) {
        self.start = start
        self.end = end
    }
}

// MARK: Self: Boundary
@available(macOS 26.0.0, *)
extension LineSegment: Boundary where Scalar: Numeric {
    // swiftlint:disable:next missing_docs
    public typealias Bound = CartesianCoordinate<n, Scalar>
    // swiftlint:disable:next missing_docs
    public static func ~= (lhs: Self, rhs: CartesianCoordinate<n, Scalar>) -> Bool {
        let ab = lhs.delta.magnitudeSquared
        let ap = (rhs .- lhs.start).components.magnitudeSquared
        let pb = (lhs.end .- rhs).components.magnitudeSquared
        return ab == ap + pb
    }
}

// MARK: Self: Ceiling
@available(macOS 26.0.0, *)
extension LineSegment: Ceiling where Scalar: Numeric {
    /// Represents the end point for the line.
    public var upperBound: CartesianCoordinate<n, Scalar> { end }
}

// MARK: Self: Floor
@available(macOS 26.0.0, *)
extension LineSegment: Floor where Scalar: Numeric {
    /// Represents the start point for the line.
    public var lowerBound: CartesianCoordinate<n, Scalar> { start }
}

// MARK: Self: Gamut
@available(macOS 26.0.0, *)
extension LineSegment: Gamut where Scalar: Numeric {
    /// Creates a new line segment based on two points.
    /// - Parameters:
    ///   - lowerBound: Initial point for the line.
    ///   - upperBound: Final point for the line.
    ///
    public init(from lowerBound: CartesianCoordinate<n, Scalar>, to upperBound: CartesianCoordinate<n, Scalar>) {
        self.init(lowerBound, to: upperBound)
    }
}

// MARK: Self: Geometric
@available(macOS 26.0.0, *)
extension LineSegment: Geometric {
    // swiftlint:disable:next missing_docs
    public typealias Coordinate = CartesianCoordinate<n, Scalar>
}

// MARK: Self.Scalar: AdditiveArithmetic
@available(macOS 26.0.0, *)
public extension LineSegment where Scalar: AdditiveArithmetic {
    var delta: Vector<n, Scalar> { (end .- start).components }
}

// MARK: CartesianCoordinate (EX)
@available(macOS 26.0.0, *)
public extension CartesianCoordinate {
    /// Creates a new line by using a range expression.
    /// - Parameters:
    ///   - lhs: Start of the line.
    ///   - rhs: End of the line.
    ///
    /// - Returns: A new `Line` instance with the two coordinates.
    static func ... (lhs: Self, rhs: Self) -> LineSegment<n, Scalar> {
        .init(lhs, to: rhs)
    }
}

// MARK: Numerics (Trait)
#if Numerics
public import Numerics

@available(macOS 26.0.0, *)
public extension LineSegment where Scalar: AlgebraicField & Comparable & ElementaryFunctions {
    /// Direction of the line, assuming it goes from start to end.
    var direction: Vector<n, Scalar> { delta.normalized }
    /// Length of the line.
    var length: Scalar { delta.magnitude }
    /// Obtains the closest point to the line.
    /// - Parameter point: Point of reference to be used.
    /// - Returns: A point in the line that is the closest to the reference point.
    func closestPoint(relatedTo point: CartesianCoordinate<n, Scalar>) -> CartesianCoordinate<n, Scalar> {
        let v1 = (point .- start).components
        let v2 = direction

        let t = v1.dot(v2)

        if t <= 0 { return start }

        if t >= length { return end }

        return start .+ .cartesian(v2 * t)
    }
    /// Obtains the minimum distance between a point and the line.
    /// - Parameter point: Point to be compared.
    /// - Returns: Distance from point to the line.
    func distance(to point: CartesianCoordinate<n, Scalar>) -> Scalar {
        let c = closestPoint(relatedTo: point)
        let delta = point .- c
        return delta.components.magnitude
    }
}
#endif
