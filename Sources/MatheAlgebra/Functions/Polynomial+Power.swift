//
//  Polynomial+Power.swift
//  Mathe
//
//  Created by Martônio Júnior on 08/05/2026.
//

#if Numerics
import MatheSIMD
public import Numerics

// MARK: Self.N == 0 (Constant)
/// Function based on a zero-degree polynomial that returns the same value independent of input.
@available(macOS 26.0, *)
public typealias ConstantFunction<T: ElementaryFunctions & AlgebraicField> = Polynomial<0, T>

@available(macOS 26.0, *)
public extension Polynomial where degree == 0 {
    /// Returns a polynomial that always returns 1 no matter the input.
    static var one: Self { .constant(1) }
    /// Returns the constant of the polynomial.
    /// - Returns: `constant`.
    func g(_: Scalar) -> Scalar { constant }
    /// Creates a new zero-degree polynomial.
    /// - Parameter k: Value for the constant.
    /// - Returns: A new polynomial.
    static func constant(_ k: Scalar) -> Self { .init([], constant: k) }
}

// MARK: Self.N == 1
/// Linear function based on a one-degree polynomial.
@available(macOS 26.0, *)
public typealias LinearFunction<T: ElementaryFunctions & AlgebraicField> = Polynomial<1, T>

@available(macOS 26.0, *)
public extension Polynomial where degree == 1 {
    /// Returns a one-degree linear polynomial with coefficient 1 and constant 0.
    /// 
    /// This makes so that the polynomial always returns it's input.
    static var unit: Self { .init([1], constant: .zero) }
    /// Creates a new one-degree polynomial.
    /// - Parameters:
    ///   - a: Most significant coefficient.
    ///   - k: Constant value.
    ///
    /// - Returns: A new polynomial in the form `f(x) = ax + k`.
    static func linear(_ a: Scalar, b: Scalar = 0) -> Self { .init([a], constant: b) }
    /// Creates a two-degree polynomial by multiplying two one-degree polynomials.
    /// - Parameters:
    ///   - lhs: Linear polynomial.
    ///   - rhs: Another Linear polynomial.
    ///
    /// - Returns: A new two-degree polynomial.
    static func * (lhs: Self, rhs: Self) -> Polynomial<2, Scalar> {
        .quadratic(
            lhs.msc * rhs.msc,
            b: lhs.msc * rhs.constant + lhs.constant * rhs.msc,
            c: lhs.constant * rhs.constant
        )
    }
}

@available(macOS 26.0, *)
extension Polynomial where degree == 2, Scalar: AlgebraicField {
    /// Returns a possible input for the given output.
    /// - Parameter y: Expected output for the polynomial.
    /// - Returns: A `Scalar` value when one is found, `nil` otherwise.
    func g(_ y: Scalar) -> Scalar? {
        guard msc != 0 else { return nil }

        let numerator = y - constant
        return numerator / msc
    }
}

// MARK: Self.N == 2
@available(macOS 26.0, *)
public typealias QuadraticFunction<T: ElementaryFunctions & AlgebraicField> = Polynomial<2, T>

@available(macOS 26.0, *)
public extension Polynomial where degree == 2 {
    /// Linear polynomial that works as a formal derivative of the current polynomial.
    var formalDerivative: Polynomial<1, Scalar> {
        .linear(
            self[e: 2] * 2,
            b: self[e: 1]
        )
    }

    static func quadratic(_ a: Scalar, b: Scalar = 0, c: Scalar = 0) -> Self { .init([a, b], constant: c) }

    static func * (lhs: Self, rhs: Polynomial<1, Scalar>) -> Polynomial<3, Scalar> {
        .cubic(
            lhs[e: 2] * rhs.msc,
            b: lhs[e: 2] * rhs.constant + lhs[e: 1] * rhs.msc,
            c: lhs[e: 1] * rhs.constant + lhs[e: 0] * rhs.msc,
            d: lhs[e: 0] * rhs.constant
        )
    }
}

// MARK: Self.N == 3
@available(macOS 26.0, *)
public typealias CubicFunction<T: ElementaryFunctions & AlgebraicField> = Polynomial<3, T>

@available(macOS 26.0, *)
public extension Polynomial where degree == 3 {
    /// Quadratic polynomial that works as a formal derivative of the current polynomial.
    var formalDerivative: Polynomial<2, Scalar> {
        .quadratic(
            self[e: 3] * 3,
            b: self[e: 2] * 2,
            c: self[e: 1]
        )
    }

    static func cubic(_ a: Scalar, b: Scalar = 0, c: Scalar = 0, d: Scalar = 0) -> Self { .init([a, b, c], constant: d) }
}
#endif
