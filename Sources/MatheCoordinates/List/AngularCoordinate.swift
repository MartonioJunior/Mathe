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
public struct AngularCoordinate<let dimensions: Int, Scalar: AdditiveArithmetic> {
    // MARK: Variables
    /// Radial distance along the line connecting the origin to the point
    public var radius: Scalar
    /// Angle between the radial line and a given polar axis
    public var angle: Vector<dimensions, Scalar>
}

// MARK: Self: CoordinateSystem
@available(macOS 26.0, *)
extension AngularCoordinate: CoordinateSystem {
    // swiftlint:disable:next missing_docs
    public typealias Components = DisplacementFor<Self>
    // swiftlint:disable:next missing_docs
    public var components: Components { .init(offset: self) }
}

// MARK: Self: Pointwise
@available(macOS 26.0, *)
extension AngularCoordinate: Pointwise {
    // swiftlint:disable:next missing_docs
    public var scalarCount: Int { angle.scalarCount + 1 }
    // swiftlint:disable:next missing_docs
    public subscript(index: Int) -> Scalar {
        get { index == 0 ? radius : angle[index - 1] }
        set {
            if index == 0 {
                radius = newValue
            } else {
                angle[index - 1] = newValue
            }
        }
    }
    // swiftlint:disable:next missing_docs
    public init(scalars: [Scalar]) {
        self.init(radius: scalars[0], angle: .init(scalars: Array(scalars.dropFirst())))
    }
}

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

    @available(macOS 26.0, *)
    static func polar<T: AdditiveArithmetic>(_ vector: Vector<2, T>) -> Self where Self == AngularCoordinate<1, T> {
        .polar(r: vector[0], a: vector[1])
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

    @available(macOS 26.0, *)
    static func spherical<T: AdditiveArithmetic>(_ vector: Vector<3, T>) -> Self where Self == AngularCoordinate<2, T> {
        .spherical(r: vector[0], theta: vector[1], phi: vector[2])
    }
}

// MARK: Numerics (Trait)
#if Numerics
public import Numerics

// MARK: PolarCoordinate (EX)
@available(macOS 26.0, *)
public extension PolarCoordinate where Scalar: Numeric & ElementaryFunctions {
    func toCartesian() -> CartesianCoordinate<2, Scalar> {
        .cartesian(x: radius * .cos(angle[0]), y: radius * .sin(angle[0]))
    }
}
#endif
