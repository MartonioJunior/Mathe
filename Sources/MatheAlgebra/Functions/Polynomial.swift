//
//  Polynomial.swift
//  Trinkets
//
//  Created by Martônio Júnior on 16/07/2025.
//

#if Numerics
public import MatheSIMD
public import Numerics

@available(macOS 26.0, *)
public struct Polynomial<let N: Int, Scalar: ElementaryFunctions & AlgebraicField> {
    // MARK: Variables
    var coefficients: InlineArray<N, Scalar>
    /// Returns the constant value for the polynomial that isn't affected by the function input.
    public var constant: Scalar { coefficients[N - 1] }
    /// Acronym of most significant coefficient.
    public var msc: Scalar { coefficients[0] }
    // MARK: Subscripts
    /// Returns the coefficient for a given power.
    /// - Parameter power: Power of the coefficient
    /// - Returns: The coefficient attached to `power`.
    public subscript(e power: Int) -> Scalar {
        guard 0..<N ~= power else { return .zero }

        return coefficients[N - power - 1]
    }
    // MARK: Initializers
    /// Creates a new polynomial from a set of coefficients
    /// - Parameter coefficients: Coefficients for the polynomial, ordered from most to least significant.
    public init(_ coefficients: InlineArray<N, Scalar>) {
        self.coefficients = coefficients
    }
    // MARK: Methods
    /// Returns the result for a given input.
    /// - Parameter x: Value used as input for the function.
    /// - Returns: The result of the polynomial with `x` as the input.
    func callAsFunction(_ x: Scalar) -> Scalar {
        (0..<N).reduce(.zero) { $0 * x + coefficients[$1] }
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
        for i in 0..<N {
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
        self.coefficients = .init {
            if elements.indices.contains($0) {
                elements[$0]
            } else {
                .zero
            }
        }
    }
}

// MARK: Self: Pointwise
@available(macOS 26.0, *)
extension Polynomial: Pointwise {
    // swiftlint:disable:next missing_docs
    public var scalarCount: Int { N }
    // swiftlint:disable:next missing_docs
    public subscript(index: Int) -> Scalar {
        get { coefficients[index] }
        set { coefficients[index] = newValue }
    }
    // swiftlint:disable:next missing_docs
    public init(scalars: [Scalar]) {
        self.init(.init { scalars[$0] })
    }
}

// MARK: Self: Sendable
@available(macOS 26.0, *)
extension Polynomial: Sendable where Scalar: Sendable {}
#endif
