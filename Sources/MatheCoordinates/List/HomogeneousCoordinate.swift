//
//  HomogeneousCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

public import MatheSIMD

@available(macOS 26.0, *)
public typealias Quaternion<let n: Int, Scalar: AdditiveArithmetic> = HomogeneousCoordinate<Vector<n, Scalar>>
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
    // MARK: Initializers
    /// Creates a new homogeneous coordinate.
    /// - Parameters:
    ///   - base: Base coordinate for the projection. 
    ///   - w: Limit for the base coordinate.
    ///
    public init(_ base: Base, w: Scalar) {
        self.base = base
        self.w = w
    }
}

// MARK: Self: CoordinateSystem
extension HomogeneousCoordinate: CoordinateSystem {
    // swiftlint:disable:next missing_docs
    public typealias Scalar = Base.Scalar
}

// MARK: Self: Pointwise
extension HomogeneousCoordinate: Pointwise where Base: Pointwise {
    // swiftlint:disable:next missing_docs
    public var scalarCount: Int { base.scalarCount + 1 }
    // swiftlint:disable:next missing_docs
    public subscript(index: Int) -> Base.Scalar {
        get { index == base.scalarCount ? w : base[index] }
        set {
            if index == base.scalarCount {
                w = newValue
            } else {
                base[index] = newValue
            }
        }
    }
    // swiftlint:disable:next missing_docs
    public init(scalars: [Base.Scalar]) {
        self = .homogeneous(Base(scalars: scalars.dropLast()), w: scalars[scalars.count - 1])
    }
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
        .init(base, w: w)
    }

    @available(macOS 26.0, *)
    static func homogeneous<Scalar: AdditiveArithmetic>(
        _ vector: Vector<4, Scalar>
    ) -> Self where Self == HomogeneousCoordinate<Vector<3, Scalar>> {
        .homogeneous([vector[0], vector[1], vector[2]], w: vector[3])
    }

    @available(macOS 26.0, *)
    static func identity<let dimensions: Int, Scalar: Numeric>() -> Self
    where Self == HomogeneousCoordinate<Vector<dimensions, Scalar>> {
        .homogeneous(atPlane: .repeating(.zero))
    }
}

public extension CoordinateSystem where Scalar: AdditiveArithmetic {
    /// Creates a new homogeneous coordinate that projects to infinity.
    /// - Parameter base: Base coordinate.
    /// - Returns: A new homogeneous coordinate with `w = 0`.
    static func homogeneous<T>(atInfinity base: T) -> Self where Self == HomogeneousCoordinate<T> {
        .init(base, w: .zero)
    }
}

public extension CoordinateSystem where Scalar: ExpressibleByIntegerLiteral {
    /// Creates a new homogeneous coordinate that is fully translated to the plane.
    /// - Parameter base: Base coordinate.
    /// - Returns: A new homogeneous coordinate with `w = 1`.
    static func homogeneous<T>(atPlane base: T) -> Self where Self == HomogeneousCoordinate<T> {
        .init(base, w: 1)
    }
}

// MARK: Numerics (Trait)
#if Numerics
public import MatheSIMD
public import Numerics

public extension HomogeneousCoordinate where Base: Pointwise {
    @available(macOS 26.0.0, *)
    static func from<T: Real>(_ matrix: Matrix<3, 3, T>) -> Self where Base == Vector<3, T> {
        let w: T = .sqrt(1 + matrix.diagonal.componentSum / 2)
        let w4 = w * 4

        return .homogeneous(.init([
            (matrix[r: 2, c: 1] - matrix[r: 1, c: 2]) / w4,
            (matrix[r: 0, c: 2] - matrix[r: 2, c: 0]) / w4,
            (matrix[r: 1, c: 0] - matrix[r: 0, c: 1]) / w4
        ]), w: w)
    }

    @available(macOS 26.0, *)
    static func lookRotation<T: Real>(
        forward: Vector<3, T>,
        up: Vector<3, T> = .up
    ) -> Self where Base == Vector<3, T> {
        let t = up.cross(forward).normalized
        let matrix = Matrix<3, 3, T>(.init([t, forward.cross(t).normalized, forward.normalized])).transposed
        return .from(matrix)
    }
}

public extension HomogeneousCoordinate where Base: Pointwise, Scalar: AlgebraicField {
    /// Returns the base coordinate, projected into it's plane.
    var translatedBase: Base { base / w }
}

public extension HomogeneousCoordinate where Base: Pointwise, Scalar: AlgebraicField & ElementaryFunctions {
    var normalized: Self { .homogeneous(atPlane: base / magnitude) }
}

public extension HomogeneousCoordinate where Base: Pointwise, Scalar: Numeric & ElementaryFunctions {
    var magnitude: Scalar { .root(dot(self), 2) }

    @available(macOS 26.0, *)
    func conjugated<let n: Int, T>() -> Self where Base == Vector<n, T> {
        self .* .homogeneous(atPlane: .repeating(-1))
    }

    @available(macOS 26.0, *)
    static func euler<let n: Int, T: Real>(_ angles: Vector<n, T>) -> Self where Base == Vector<n, T> {
        .homogeneous(atInfinity: angles)
    }

    @available(macOS 26.0, *)
    static func from<let n: Int, T: Real>(axis: Vector<n, T>, angle: T) -> Self where Base == Vector<n, T> {
        .homogeneous(atInfinity: axis * angle)
    }
}
#else
public extension HomogeneousCoordinate where Base: Pointwise, Scalar: FloatingPoint {
    /// Returns the base coordinate, projected into it's plane.
    var translatedBase: Base { base / w }
}
#endif
