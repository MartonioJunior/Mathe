//
//  AngularCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 04/05/2026.
//

public import MatheSIMD

/// Angular coordinate defined by pole (origin) and a polar axis
@available(macOS 26.0, *)
public typealias PolarCoordinate<Scalar: AdditiveArithmetic> = AngularCoordinate<1, Scalar>
/// Angular coordinate defined by adding an angle to a polar coordinate
@available(macOS 26.0, *)
public typealias SphericalCoordinate<Scalar: AdditiveArithmetic> = AngularCoordinate<2, Scalar>

/// Coordinate system that is defined by a radius combined with a set of angles
@available(macOS 26.0, *)
public struct AngularCoordinate<let N: Int, Scalar: AdditiveArithmetic> {
    // MARK: Variables
    /// Radial distance along the line connecting the origin to the point
    public var radius: Scalar
    /// Angle between the radial line and a given polar axis
    public var angle: Vector<N, Scalar>
}

// MARK: Self: CoordinateSystem
@available(macOS 26.0, *)
extension AngularCoordinate: CoordinateSystem {}

// MARK: CoordinateSystem (EX)
@available(macOS 26.0, *)
public extension CoordinateSystem {
    /// Creates a new polar coordinate
    /// - Parameters:
    ///   - r: Radial distance from origin
    ///   - a: Polar angle for a given polar axis
    ///
    /// - Returns: A new `AngularCoordinate` instance where `N = 1`
    static func polar<T: AdditiveArithmetic>(r: T, a: T) -> Self where Self == AngularCoordinate<1, T> {
        .init(radius: r, angle: [a])
    }
    /// Creates a new spherical coordinate
    /// - Parameters:
    ///   - radius: Radial distance from the origin
    ///   - theta: Polar angle for a given polar axis
    ///   - phi: Azimuthal angle of rotation
    ///
    /// - Returns: A new `AngularCoordinate` instance where `N = 2`
    static func spherical<T: AdditiveArithmetic>(
        r radius: T,
        theta: T,
        phi: T
    ) -> Self where Self == AngularCoordinate<2, T> {
        .init(radius: radius, angle: [theta, phi])
    }
}
