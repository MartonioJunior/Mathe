//
//  Ray.swift
//  Mathe
//
//  Created by Martônio Júnior on 05/05/2026.
//

#if Numerics
public import MatheCoordinates
public import MatheRange
public import MatheSIMD
public import Numerics

/// Directed line segment.
/// 
/// Can be extended indefinitely in one direction from a point of origin using it's direction.
@available(macOS 26.0.0, *)
public struct Ray<let n: Int, Scalar: AlgebraicField & ElementaryFunctions & Comparable> {
    // MARK: Variables
    /// Coordinate at the origin of the ray
    public var origin: CartesianCoordinate<n, Scalar>
    /// Length of the ray.
    public var length: Scalar
    /// Direction of the ray.
    public var direction: Vector<n, Scalar> {
        didSet { direction = direction.normalized }
    }
    /// Delta vector towards the endpoint of the ray.
    public var delta: Vector<n, Scalar> { direction * length }
    /// Endpoint of the ray.
    public var endpoint: CartesianCoordinate<n, Scalar> { origin.pointwise(delta, merge: +) }
    // MARK: Initializers
    /// Creates a new ray from an origin point and direction vector.
    /// - Parameters:
    ///   - origin: Coordinate where the ray starts from.
    ///   - direction: Direction that the ray extends towards.
    ///   - length: Size of the ray.
    ///
    public init(_ origin: CartesianCoordinate<n, Scalar>, direction: Vector<n, Scalar>, length: Scalar = 1) {
        self.origin = origin
        self.direction = direction
        self.length = length
    }
    /// Creates a new ray from a line segment, assuming direction flows from start to end.
    /// - Parameter line: Line segment.
    public init(_ line: LineSegment<n, Scalar>) {
        let delta = line.delta

        self.origin = line.start
        self.length = delta.magnitude
        self.direction = delta
    }
}

// MARK: DotSyntax
@available(macOS 26.0.0, *)
public extension Ray {
    /// Creates a ray based on a direction and distance from the origin of the coordinate system.
    /// - Parameters:
    ///   - distance: Distance from origin.
    ///   - normal: Normal of the ray.
    ///
    /// - Returns: Ray that acts as the normal for a line.
    static func distance(_  distance: Scalar, direction: Vector<n, Scalar>) -> Self {
        .normal(origin: .cartesian(direction.normalized * distance), direction: direction)
    }
    /// Creates a new ray from an origin point and direction vector.
    /// - Parameters:
    ///   - origin: Coordinate where the ray starts from.
    ///   - direction: Direction that the ray extends towards.
    /// - Returns: Straight line extending indefinitely in one direction from a point of origin.
    static func normal(origin: CartesianCoordinate<n, Scalar>, direction: Vector<n, Scalar>) -> Self {
        .init(origin, direction: direction)
    }
}

// MARK: Self: Boundary
@available(macOS 26.0.0, *)
extension Ray: Boundary {
    // swiftlint:disable:next missing_docs
    public typealias Bound = CartesianCoordinate<n, Scalar>
    // swiftlint:disable:next missing_docs
    public static func ~= (lhs: Self, rhs: CartesianCoordinate<n, Scalar>) -> Bool {
        let delta = (rhs .- lhs.origin).components
        let t = delta.dot(lhs.direction)

        return (0...lhs.length).contains(t) && lhs.point(at: t) == rhs
    }
}

// MARK: Self.Scalar: Numeric
@available(macOS 26.0.0, *)
public extension Ray where Scalar: Numeric {
    /// Returns a point at a given distance from the ray.
    /// - Parameter distance: Distance from the origin of the ray.
    /// - Returns: A new coordinate that's `distance` units away from the origin.
    func point(at distance: Scalar) -> CartesianCoordinate<n, Scalar> {
        .cartesian(origin.components .+ direction * distance)
    }
}
#endif
