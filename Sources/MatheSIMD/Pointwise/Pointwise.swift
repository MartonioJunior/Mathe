//
//  Pointwise.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/09/2025.
//

/// Protocol that allows point-to-point operations
public protocol Pointwise {
    associatedtype Scalar

    var scalarCount: Int { get }

    subscript(_ index: Int) -> Scalar { get set }

    init(scalars: [Scalar])
}

// MARK: Default Implementation
public extension Pointwise {
    var scalarIndices: Range<Int> { 0..<scalarCount }

    func callAsFunction(point merge: (Scalar, Scalar) -> Scalar, scalar: Scalar) -> Self {
        pointwise(scalar: scalar, merge: merge)
    }

    func callAsFunction(point merge: (Scalar, Scalar) -> Scalar, _ rhs: Self) -> Self {
        pointwise(rhs, merge: merge)
    }

    func pointwise(scalar: Scalar, merge: (Scalar, Scalar) -> Scalar) -> Self {
        .init(scalars: scalarIndices.map { merge(self[$0], scalar) })
    }

    func pointwise(_ rhs: Self, merge: (Scalar, Scalar) -> Scalar) -> Self {
        .init(scalars: scalarIndices.map { merge(self[$0], rhs[$0]) })
    }

    func reduce(_ initialResult: Scalar, _ nextInitialResult: (Scalar, Scalar) -> Scalar) -> Scalar {
        scalarIndices.map { self[$0] }.reduce(initialResult, nextInitialResult)
    }
}

// MARK: Scalar: AdditiveArithmetic
public extension Pointwise where Scalar: AdditiveArithmetic {
    @_disfavoredOverload
    static func + (lhs: Self, rhs: Scalar) -> Self { lhs.pointwise(scalar: rhs, merge: +)}
    @_disfavoredOverload
    static func .+ (lhs: Self, rhs: Self) -> Self { lhs.pointwise(rhs, merge: +) }
    @_disfavoredOverload
    static func - (lhs: Self, rhs: Scalar) -> Self { lhs.pointwise(scalar: rhs, merge: -)}
    @_disfavoredOverload
    static func .- (lhs: Self, rhs: Self) -> Self { lhs.pointwise(rhs, merge: -) }
}

// MARK: Scalar: Numeric
public extension Pointwise where Scalar: Numeric {
    func dot(_ rhs: Self) -> Scalar { pointwise(rhs, merge: *).reduce(1, +) }

    @_disfavoredOverload
    static func * (lhs: Self, rhs: Scalar) -> Self { lhs.pointwise(scalar: rhs, merge: *)}
    @_disfavoredOverload
    static func .* (lhs: Self, rhs: Self) -> Self { lhs.pointwise(rhs, merge: *) }
}

// MARK: Scalar: FloatingPoint
public extension Pointwise where Scalar: FloatingPoint {
    @_disfavoredOverload
    static func / (lhs: Self, rhs: Scalar) -> Self { lhs.pointwise(scalar: rhs, merge: /)}
    @_disfavoredOverload
    static func ./ (lhs: Self, rhs: Self) -> Self { lhs.pointwise(rhs, merge: /) }
}
