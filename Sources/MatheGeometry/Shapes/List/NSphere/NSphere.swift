//
//  Sphere.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/05/2026.
//

public import MatheCoordinates
import MatheSIMD

/// Structure that defines a n-sphere.
/// 
/// Origin for the shape is at it's center.
@available(macOS 26.0.0, *)
public struct NSphere<let n: Int, Scalar: Numeric> {
    // MARK: Variables
    /// Radius of the sphere.
    var radius: Scalar

    var bounds: CellShaped.ByExtent<n, Scalar> {
        .init(.repeating(radius))
    }
    /// Diamater of the sphere.
    var diameter: Scalar { radius + radius }
}

// MARK: Self: Shape
@available(macOS 26.0, *)
extension NSphere: Shape {
    // swiftlint:disable:next missing_docs
    public typealias Coordinate = CartesianCoordinate<n, Scalar>
    // swiftlint:disable:next missing_docs
    public var isClosed: Bool { true }
    // swiftlint:disable:next missing_docs
    public func isOutline(for point: Coordinate) -> Bool {
        point.magnitudeSquared == 1
    }
}

// MARK: Placed (EX)
@available(macOS 26.0.0, *)
public extension Placed {
    func bounds<let n: Int, Scalar>() -> Placed<CellShaped.ByExtent<n, Scalar>, CartesianCoordinate<n, Scalar>>
    where Element == NSphere<n, Scalar>, Coordinate == CartesianCoordinate<n, Scalar> {
        .init(element.bounds, in: position)
    }
}

// MARK: Numerics (Trait)
#if Numerics
public import Numerics

@available(macOS 26.0.0, *)
extension NSphere where Scalar: AlgebraicField & ElementaryFunctions & Comparable {
    func distanceFromBorder(for point: Coordinate) -> Scalar {
        let delta = point.components
        return 1 - (delta.magnitude / radius)
    }
}

@available(macOS 26.0.0, *)
public extension NSphere where Scalar: Real {
    /// Circumference of the sphere.
    var circumference: Scalar { diameter * .pi }
}
#endif
