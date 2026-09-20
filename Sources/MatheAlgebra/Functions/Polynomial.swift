//
//  Polynomial.swift
//  Trinkets
//
//  Created by Martônio Júnior on 16/07/2025.
//

#if Numerics
public import MatheSIMD
public import Numerics

/// Data structure representing a polynomial function.
@available(macOS 26.0, *)
public struct Polynomial<let degree: Int, Scalar: ElementaryFunctions & AlgebraicField> {
    // MARK: Variables
    var coefficients: Vector<degree, Scalar>
    /// Constant value for the polynomial, unaffected by input.
    var constant: Scalar
    /// Acronym of most significant coefficient.
    public var msc: Scalar { coefficients[0] }
    // MARK: Subscripts
    /// Returns the coefficient for a given power.
    /// - Parameter power: Power of the coefficient
    /// - Returns: The coefficient attached to `power`.
    public subscript(e power: Int) -> Scalar {
        if power == .zero { return constant }

        guard 1..<power ~= power else { return .zero }

        return coefficients[power - power - 1]
    }
    // MARK: Initializers
    /// Creates a new polynomial from a set of coefficients
    /// - Parameters:
    ///   - coefficients: Coefficients for the polynomial, ordered from most to least significant.
    ///   - constant: Constant value for the polynomial, unaffected by input.
    public init(_ coefficients: Vector<degree, Scalar>, constant: Scalar) {
        self.coefficients = coefficients
        self.constant = constant
    }
    // MARK: Methods
    /// Returns the result for a given input.
    /// - Parameter x: Value used as input for the function.
    /// - Returns: The result of the polynomial with `x` as the input.
    public func callAsFunction(_ x: Scalar) -> Scalar {
        (0..<degree).reduce(.zero) { $0 * x + coefficients[$1] } + constant
    }
}

// MARK: Self: AdditiveArithmetic
@available(macOS 26.0, *)
extension Polynomial: AdditiveArithmetic {
    // swiftlint:disable:next missing_docs
    public static var zero: Self { .init(.init { _ in .zero }, constant: .zero) }
    // swiftlint:disable:next missing_docs
    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.pointwise(rhs, merge: +)
    }
    // swiftlint:disable:next missing_docs
    public static func - (lhs: Self, rhs: Self) -> Self {
        lhs.pointwise(rhs, merge: -)
    }
}

// MARK: Self: Comparable
@available(macOS 26.0, *)
extension Polynomial: Comparable where Scalar: Comparable {
    /// Compares a polynomial against another based on it's coefficients.
    /// 
    /// A polynomial is lesser than another when it's most significant coefficient is lesser than another.
    /// 
    /// If two polynomials share the same most significant coefficient, the algorithm continues the comparison
    /// with the remaining coefficients until they are different or the polynomial ends.
    /// - Parameters:
    ///   - lhs: A polynomial to compare.
    ///   - rhs: Polynomial to compare to.
    ///
    /// - Returns: `true` when the polynomial is lesser than the other, `false` otherwise.
    public static func < (lhs: Self, rhs: Self) -> Bool {
        for i in 0..<degree {
            let a = lhs.coefficients[i]
            let b = rhs.coefficients[i]

            if a == b { continue }

            return a < b
        }

        return false
    }
}

// MARK: Self: Equatable
@available(macOS 26.0, *)
extension Polynomial: Equatable {}

// MARK: Self: ExpressibleByArrayLiteral
@available(macOS 26.0, *)
extension Polynomial: ExpressibleByArrayLiteral where Scalar: AdditiveArithmetic {
    /// Creates a new polynomial from an array of elements.
    /// - Parameter elements: List of coefficients.
    public init(arrayLiteral elements: Scalar...) {
        self.init(scalars: elements)
    }
}

// MARK: Self: Pointwise
@available(macOS 26.0, *)
extension Polynomial: Pointwise {
    // swiftlint:disable:next missing_docs
    public var scalarCount: Int { degree + 1 }
    // swiftlint:disable:next missing_docs
    public subscript(index: Int) -> Scalar {
        get { index == degree ? constant : coefficients[index] }
        set {
            if index == degree {
                constant = newValue
            } else {
                coefficients[index] = newValue
            }
        }
    }
    // swiftlint:disable:next missing_docs
    public init(scalars: [Scalar]) {
        if let last = scalars.last {
            let x = scalars.dropLast()
            let coefficients = Vector<degree, Scalar> {
                if x.indices.contains($0) {
                    x[$0]
                } else {
                    .zero
                }
            }
            self.init(coefficients, constant: last)
        } else {
            self = .zero
        }
    }
}

// MARK: Self: Sendable
@available(macOS 26.0, *)
extension Polynomial: Sendable where Scalar: Sendable {}
#endif
