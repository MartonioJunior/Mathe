//
//  HomogeneousCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

/// Coordinate system that can represent any point on the projective plane without using infinity as a value.
/// 
/// Also known as a projective coordinate.
public struct HomogeneousCoordinate<Base: CoordinateSystem> {
    // MARK: Variables
    /// Base coordinate used as the base of the projection.
    public var base: Base
    /// Defines the limit for the base coordinate.
    /// 
    /// - When `w` is zero, the point for the base coordinate is at infinity.
    /// - When `w` is not zero, the point is a projection in the given base coordinate space.
    public var w: Scalar
}

// MARK: Self: CoordinateSystem
extension HomogeneousCoordinate: CoordinateSystem {
    // swiftlint:disable:next missing_docs
    public typealias Scalar = Base.Scalar
}

// MARK: Self.Scalar: AdditiveArithmetic
extension HomogeneousCoordinate where Scalar: AdditiveArithmetic {
    var isAtInfinity: Bool { w == .zero }
}

// MARK: Self.Scalar: Numeric
public extension HomogeneousCoordinate where Scalar: Numeric {
    /// Is the coordinate a point in the plane?
    var isTranslatedToPlane: Bool { w == 1 }
}

// MARK: CoordinateSystem (EX)
public extension CoordinateSystem {
    /// Creates a new homogeneous coordinate from a base coordinate and a limit value.
    /// - Parameters:
    ///   - base: Base coordinate.
    ///   - w: Limit for the base coordinate.
    ///
    /// - Returns: A new homogeneous coordinate.
    static func homogeneous<T>(_ base: T, w: Scalar) -> Self where Self == HomogeneousCoordinate<T> {
        .init(base: base, w: w)
    }
}

public extension CoordinateSystem where Scalar: AdditiveArithmetic {
    /// Creates a new homogeneous coordinate that projects to infinity.
    /// - Parameter base: Base coordinate.
    /// - Returns: A new homogeneous coordinate with `w = 0`.
    static func homogeneous<T>(atInfinity base: T) -> Self where Self == HomogeneousCoordinate<T> {
        .init(base: base, w: .zero)
    }
}

public extension CoordinateSystem where Scalar: ExpressibleByIntegerLiteral {
    /// Creates a new homogeneous coordinate that is fully translated to the plane.
    /// - Parameter base: Base coordinate.
    /// - Returns: A new homogeneous coordinate with `w = 1`.
    static func homogeneous<T>(atPlane base: T) -> Self where Self == HomogeneousCoordinate<T> {
        .init(base: base, w: 1)
    }
}

// MARK: Numerics (Trait)
#if Numerics
public import MatheSIMD
public import Numerics

public extension HomogeneousCoordinate where Base: Pointwise, Scalar: AlgebraicField {
    /// Returns the base coordinate, projected into it's plane.
    var translatedBase: Base { base / w }
}
#else
public extension HomogeneousCoordinate where Base: Pointwise, Scalar: FloatingPoint {
    /// Returns the base coordinate, projected into it's plane.
    var translatedBase: Base { base / w }
}
#endif
