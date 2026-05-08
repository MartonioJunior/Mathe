//
//  Line.swift
//  Mathe
//
//  Created by Martônio Júnior on 06/05/2026.
//

public import MatheCoordinates
public import MatheRange
import MatheSIMD

/// Data structure that represents part of a line delimited by two points.
@available(macOS 26.0.0, *)
public struct Line<let N: Int, Scalar: AdditiveArithmetic> {
    // MARK: Variables
    /// Initial point for the line.
    public var a: CartesianCoordinate<N, Scalar>
    /// Final point for the line.
    public var b: CartesianCoordinate<N, Scalar>
    // MARK: Initializers
    /// Creates a new line segment based on two points.
    /// - Parameters:
    ///   - a: Initial point for the line.
    ///   - b: Final point for the line.
    ///
    public init(_ a: CartesianCoordinate<N, Scalar>, to b: CartesianCoordinate<N, Scalar>) {
        self.a = a
        self.b = b
    }
}

// MARK: Self: Boundary
@available(macOS 26.0.0, *)
extension Line: Boundary where Scalar: Numeric {
    // swiftlint:disable:next missing_docs
    public typealias Bound = CartesianCoordinate<N, Scalar>
    // swiftlint:disable:next missing_docs
    public static func ~= (lhs: Self, rhs: CartesianCoordinate<N, Scalar>) -> Bool {
        let ab = (lhs.b .- lhs.a).components.magnitudeSquared
        let ap = (rhs .- lhs.a).components.magnitudeSquared
        let pb = (lhs.b .- rhs).components.magnitudeSquared
        return ab == ap + pb
    }
}

// MARK: Self: Ceiling
@available(macOS 26.0.0, *)
extension Line: Ceiling where Scalar: Numeric {
    /// Represents the end point for the line.
    public var upperBound: CartesianCoordinate<N, Scalar> { b }
}

// MARK: Self: Floor
@available(macOS 26.0.0, *)
extension Line: Floor where Scalar: Numeric {
    /// Represents the start point for the line.
    public var lowerBound: CartesianCoordinate<N, Scalar> { a }
}

// MARK: Self: Gamut
@available(macOS 26.0.0, *)
extension Line: Gamut where Scalar: Numeric {
    /// Creates a new line segment based on two points.
    /// - Parameters:
    ///   - lowerBound: Initial point for the line.
    ///   - upperBound: Final point for the line.
    ///
    public init(from lowerBound: CartesianCoordinate<N, Scalar>, to upperBound: CartesianCoordinate<N, Scalar>) {
        self.init(lowerBound, to: upperBound)
    }
}

// MARK: Self: Geometric
@available(macOS 26.0.0, *)
extension Line: Geometric {
    // swiftlint:disable:next missing_docs
    public typealias Coordinate = CartesianCoordinate<N, Scalar>
}

// MARK: Numerics (Trait)
#if Numerics
public import Numerics

@available(macOS 26.0.0, *)
public extension Line where Scalar: AlgebraicField & Comparable & ElementaryFunctions {
    /// Obtains the closest point to the line.
    /// - Parameter point: Point of reference to be used.
    /// - Returns: A point in the line that is the closest to the reference point.
    func closestPoint(relatedTo point: CartesianCoordinate<N, Scalar>) -> CartesianCoordinate<N, Scalar> {
        let v1 = (point .- a).components
        let v2 = (b .- a).normalized

        let t = v1.dot(v2)

        if t <= 0 { return a }

        if t >= (b .- a).magnitude { return b }

        return a .+ .cartesian(v2 * t)
    }
}
#endif
