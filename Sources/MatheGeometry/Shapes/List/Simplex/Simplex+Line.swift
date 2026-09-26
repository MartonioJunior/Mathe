//
//  Simplex+Line.swift
//  Mathe
//
//  Created by Martônio Júnior on 06/05/2026.
//

public import MatheCoordinates
public import MatheRange
public import MatheSIMD
/// Data structure that represents a line segment, delimited by two points.
@available(macOS 26.0.0, *)
public typealias LineSegment<let n: Int, Scalar: AdditiveArithmetic> = Simplex<1, CartesianCoordinate<n, Scalar>>

@available(macOS 26.0.0, *)
public extension Simplex where n == 1 {
    /// Initial point for the line.
    var start: Vertex {
        get { base[0] }
        set { base[0] = newValue }
    }
    /// Line that has start and end points swapped around.
    var flipped: Self { .init(end, to: start) }
    /// Creates a new line segment based on two points.
    /// - Parameters:
    ///   - start: Initial point for the line.
    ///   - end: Final point for the line.
    ///
    init(_ start: Vertex, to end: Vertex) {
        self.base = .init([start])
        self.end = end
    }
}

// MARK: Self: Ceiling
@available(macOS 26.0.0, *)
extension Simplex: Ceiling where n == 1 {
    /// Represents the end point for the line.
    public var upperBound: Vertex { end }
}

// MARK: Self: Floor
@available(macOS 26.0.0, *)
extension Simplex: Floor where n == 1 {
    /// Represents the start point for the line.
    public var lowerBound: Vertex { start }
}

// MARK: Self: Gamut
@available(macOS 26.0.0, *)
extension Simplex: Gamut where n == 1 {
    /// Creates a new line segment based on two points.
    /// - Parameters:
    ///   - lowerBound: Initial point for the line.
    ///   - upperBound: Final point for the line.
    ///
    public init(from lowerBound: Vertex, to upperBound: Vertex) {
        self.init(lowerBound, to: upperBound)
    }
}

// MARK: Self.Vertex: Pointwise
@available(macOS 26.0.0, *)
public extension Simplex where n == 1, Vertex: CoordinateSystem & Pointwise, Vertex.Scalar == Vertex.Components.Scalar, Vertex.Scalar: AdditiveArithmetic {
    /// Displacement vertex of the line segment.
    var delta: Vertex.Components { (end .- start).components }
}

@available(macOS 26.0.0, *)
public extension Simplex where n == 1, Vertex: CoordinateSystem & Pointwise, Vertex.Scalar == Vertex.Components.Scalar, Vertex.Scalar: Numeric {
    // swiftlint:disable:next missing_docs
    static func ~= (lhs: Self, rhs: Vertex) -> Bool {
        let ab = lhs.delta.magnitudeSquared
        let ap = Self(from: lhs.start, to: rhs).delta.magnitudeSquared
        let pb = Self(from: rhs, to: lhs.end).delta.magnitudeSquared
        return ab == ap + pb
    }
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
    static func ... (lhs: Self, rhs: Self) -> Simplex<1, Self> {
        .init(from: lhs, to: rhs)
    }
}

// MARK: Numerics (Trait)
#if Numerics
public import Numerics

@available(macOS 26.0.0, *)
public extension Simplex where n == 1, Vertex: CoordinateSystem & Pointwise, Vertex.Scalar == Vertex.Components.Scalar, Vertex.Scalar: AlgebraicField & Comparable & ElementaryFunctions {
    /// Direction of the line, assuming it goes from start to end.
    var direction: Vertex.Components { delta.normalized }
    /// Length of the line.
    var length: Vertex.Scalar { delta.magnitude }
    /// Obtains the closest point to the line.
    /// - Parameter point: Point of reference to be used.
    /// - Returns: A point in the line that is the closest to the reference point.
    func closestPoint(relatedTo point: Vertex) -> Vertex {
        let v1 = Self(from: start, to: point).delta
        let v2 = direction

        let t = v1.dot(v2)

        if t <= 0 { return start }

        if t >= length { return end }

        let displacement = v2.pointwise(scalar: t, merge: *)
        return start.offset(by: displacement)
    }
    /// Obtains the minimum distance between a point and the line.
    /// - Parameter point: Point to be compared.
    /// - Returns: Distance from point to the line.
    func distance(to point: Vertex) -> Vertex.Scalar {
        let c = closestPoint(relatedTo: point)
        return Self(from: c, to: point).delta.magnitude
    }
}
#endif
