//
//  Plane.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/05/2026.
//

#if Numerics
public import MatheCoordinates
import MatheRange
public import MatheSIMD
public import Numerics

/// Data structure that represents a N-dimensional plane/
@available(macOS 26.0.0, *)
public struct Plane<let n: Int, Scalar: AlgebraicField & Comparable & ElementaryFunctions> {
    // MARK: Variables
    /// Ray used as the base to define the plane.
    var base: Ray<n, Scalar>
    /// Normal of the plane.
    public var normal: Vector<n, Scalar> { base.direction }
    /// Origin of the plane.
    public var origin: CartesianCoordinate<n, Scalar> { base.origin }
    // MARK: Initializers
    /// Creates a new plane from a given ray.
    /// - Parameters:
    ///   - ray: Ray that represents the plane.
    public init(_ ray: Ray<n, Scalar>) {
        self.base = ray
    }
    /// Creates a new plane from origin and direction.
    /// - Parameters:
    ///   - origin: Origin of the plane.
    ///   - direction: Normal of the plane.
    public init(_ origin: CartesianCoordinate<n, Scalar>, direction: Vector<n, Scalar>) {
        self.base = .normal(origin: origin, direction: direction)
    }
    // MARK: Methods
    /// Returns the relative distance between point and plane.
    /// - Parameter point: Coordinate in space.
    /// - Returns: The signed value representing the height of the point in relation to the plane.
    public func height(for point: CartesianCoordinate<n, Scalar>) -> Scalar {
        let distanceVector = (point .- base.origin).components
        return distanceVector.scalarProjection(on: base.direction)
    }
}

// MARK: DotSyntax
@available(macOS 26.0.0, *)
public extension Plane {
    /// Creates a new plane out of three points.
    /// - Parameters:
    ///   - a: First point in space d.
    ///   - b: Second point in space.
    ///   - c: Third point in space.
    ///
    /// - Returns: A new plane, with the first point as it's origin.
    static func fromPoints(
        _ a: CartesianCoordinate<n, Scalar>,
        _ b: CartesianCoordinate<n, Scalar>,
        _ c: CartesianCoordinate<n, Scalar>
    ) -> Self where n == 3 {
        let e3 = (b .- a).components
        let e1 = (c .- b).components
        let normal = e3.cross(e1) / e3.cross(e1).magnitudeSquared
        return .init(a, direction: normal)
    }

    // TODO: Create a new plane from any number of points (best-fit approach)
}

#endif
