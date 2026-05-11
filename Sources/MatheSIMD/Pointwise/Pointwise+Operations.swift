//
//  Pointwise+Operations.swift
//  Mathe
//
//  Created by Martônio Júnior on 11/05/2026.
//

#if Numerics
public import Numerics
#endif

// MARK: Scalar: AdditiveArithmetic
public extension Pointwise where Scalar: AdditiveArithmetic {
    /// Sum of the components
    var componentSum: Scalar { reduce(.zero, +) }
    /// Point-by-point addition of a pointwise with a scalar.
    /// - Parameters:
    ///   - lhs: A pointwise value. 
    ///   - rhs: A scalar value.
    ///
    /// - Returns: Pointwise where each component was added a scalar value.
    @_disfavoredOverload
    static func + (lhs: Self, rhs: Scalar) -> Self { lhs.pointwise(scalar: rhs, merge: +)}
    /// Point-by-point addition of a pointwise with another.
    /// - Parameters:
    ///   - lhs: A pointwise value.
    ///   - rhs: Another pointwise value.
    ///
    /// - Returns: Pointwise with their components added together.
    @_disfavoredOverload
    static func .+ (lhs: Self, rhs: Self) -> Self { lhs.pointwise(rhs, merge: +) }
    /// Point-by-point subtraction of a scalar value from a pointwise.
    /// - Parameters:
    ///   - lhs: A pointwise value.
    ///   - rhs: A scalar value.
    ///
    /// - Returns: Pointwise where each component was subtracted a scalar value.
    @_disfavoredOverload
    static func - (lhs: Self, rhs: Scalar) -> Self { lhs.pointwise(scalar: rhs, merge: -)}
    /// Point-by-point subtraction of a pointwise from a scalar value.
    /// - Parameters:
    ///   - lhs: A scalar value.
    ///   - rhs: A pointwise value.
    ///
    /// - Returns: Pointwise composed of the subtraction of scalar value per each pointwise component.
    @_disfavoredOverload
    static func .- (lhs: Scalar, rhs: Self) -> Self { rhs.pointwise(scalar: lhs) { $1 - $0 } }
    /// Point-by-point subtraction of a pointwise from another.
    /// - Parameters:
    ///   - lhs: A pointwise value.
    ///   - rhs: Another pointwise value.
    ///
    /// - Returns: Pointwise where each component was subtracted from the other.
    @_disfavoredOverload
    static func .- (lhs: Self, rhs: Self) -> Self { lhs.pointwise(rhs, merge: -) }
}

// MARK: Scalar == Bool
public extension Pointwise where Scalar == Bool {
    /// Are all components `true`?
    var all: Bool { reduce(true) { $0 && $1 } }
    /// Is any component `true`?
    var any: Bool { reduce(false) { $0 || $1 } }
}

// MARK: Scalar == Comparable
public extension Pointwise where Scalar: Comparable {
    /// Scalar and index for the greater component.
    var max: (value: Scalar, scalarIndex: Int) { reduceCompare(>) }
    /// Scalar and index for the lesser component.
    var min: (value: Scalar, scalarIndex: Int) { reduceCompare(<) }
    /// Attempts to identify the greater component for a comparison.
    /// - Parameter compare: Comparison predicate.
    /// - Returns: Scalar and index for the greater component for the comparison.
    func reduceCompare(_ compare: (Scalar, Scalar) -> Bool) -> (value: Scalar, scalarIndex: Int) {
        scalarIndices.dropFirst().reduce((value: self[0], scalarIndex: 0)) {
            let element = self[$1]
            return compare($0.value, element) ? (element, $1) : $0
        }
    }
}

// MARK: Scalar: Equatable
public extension Pointwise where Scalar: Equatable {
    /// Checks whether all components are the same as a given scalar.
    /// - Parameter value: Scalar to compare to.
    /// - Returns: `true` when all components are equal to `value`, `false` otherwise.
    func all(_ value: Scalar) -> Bool { scalarIndices.allSatisfy { self[$0] == value } }
    /// Checks whether any components are the same as a given scalar.
    /// - Parameter value: Scalar to compare to.
    /// - Returns: `true` when any component is equal to `value`, `false` otherwise.
    func any(_ value: Scalar) -> Bool { scalarIndices.contains { self[$0] == value } }
}

// MARK: Scalar: FloatingPoint
#if Numerics
public extension Pointwise where Scalar: AlgebraicField {
    /// Point-by-point division of a pointwise by a scalar.
    /// - Parameters:
    ///   - lhs: A pointwise value.
    ///   - rhs: A scalar divisor.
    ///
    /// - Returns: Quotient pointwise of each component by the scalar.
    @_disfavoredOverload
    static func / (lhs: Self, rhs: Scalar) -> Self { lhs.pointwise(scalar: rhs, merge: /) }
    /// Point-by-point division of a pointwise by another.
    /// - Parameters:
    ///   - lhs: A pointwise value.
    ///   - rhs: A pointwise divisor.
    ///
    /// - Returns: Quotient pointwise that performs a point-by-point division with another pointwise.
    @_disfavoredOverload
    static func ./ (lhs: Self, rhs: Self) -> Self { lhs.pointwise(rhs, merge: /) }
}
#else
public extension Pointwise where Scalar: FloatingPoint {
    /// Point-by-point division of a pointwise by a scalar.
    /// - Parameters:
    ///   - lhs: A pointwise value.
    ///   - rhs: A scalar divisor.
    ///
    /// - Returns: Quocient pointwise of each component by the scalar.
    @_disfavoredOverload
    static func / (lhs: Self, rhs: Scalar) -> Self { lhs.pointwise(scalar: rhs, merge: /) }
    /// Point-by-point division of a pointwise by another.
    /// - Parameters:
    ///   - lhs: A pointwise value.
    ///   - rhs: A pointwise divisor.
    ///
    /// - Returns: Quotient pointwise that performs a point-by-point division with another pointwise.
    @_disfavoredOverload
    static func ./ (lhs: Self, rhs: Self) -> Self { lhs.pointwise(rhs, merge: /) }
}
#endif

// MARK: Scalar: Numeric
public extension Pointwise where Scalar: Numeric {
    /// Product of all components.
    var componentProduct: Scalar { reduce(1, *) }
    /// Performs the dot product against another pointwise.
    /// - Parameter rhs: Another pointwise.
    /// - Returns: A scalar representing the component sum of the product of two pointwise instances.
    func dot(_ rhs: Self) -> Scalar { pointwise(rhs, merge: *).reduce(0, +) }
    /// Point-by-point multiplication of a pointwise by a scalar.
    /// - Parameters:
    ///   - lhs: A pointwise value.
    ///   - rhs: A scalar value.
    ///
    /// - Returns: A pointwise where each component was multiplied by a scalar.
    @_disfavoredOverload
    static func * (lhs: Self, rhs: Scalar) -> Self { lhs.pointwise(scalar: rhs, merge: *) }
    /// Point-by-point multiplication of a pointwise against another
    /// - Parameters:
    ///   - lhs: A pointwise value.
    ///   - rhs: Another pointwise value.
    ///
    /// - Returns: A pointwise that is the product of their components.
    @_disfavoredOverload
    static func .* (lhs: Self, rhs: Self) -> Self { lhs.pointwise(rhs, merge: *) }
}

// MARK: Scalar: SignedInteger
public extension Pointwise where Scalar: SignedInteger {
    /// Point-by-point division of a pointwise by a scalar.
    /// - Parameters:
    ///   - lhs: A pointwise value.
    ///   - rhs: A scalar divisor.
    ///
    /// - Returns: Quocient pointwise of each component by the scalar.
    @_disfavoredOverload
    static func / (lhs: Self, rhs: Scalar) -> Self { lhs.pointwise(scalar: rhs, merge: /) }
    /// Point-by-point division of a pointwise by another.
    /// - Parameters:
    ///   - lhs: A pointwise value.
    ///   - rhs: A pointwise divisor.
    ///
    /// - Returns: Quotient pointwise that performs a point-by-point division with another pointwise.
    @_disfavoredOverload
    static func ./ (lhs: Self, rhs: Self) -> Self { lhs.pointwise(rhs, merge: /) }
    /// Point-by-point modulo of a pointwise by a scalar
    /// - Parameters:
    ///   - lhs: A pointwise value
    ///   - rhs: A scalar value
    ///
    /// - Returns: Pointwise composed of the remainders of each component in a division by scalar.
    @_disfavoredOverload
    static func % (lhs: Self, rhs: Scalar) -> Self { lhs.pointwise(scalar: rhs, merge: %) }
}

// MARK: Scalar: SignedNumeric
public extension Pointwise where Scalar: SignedNumeric {
    /// Point-by-point negation of each component.
    /// - Parameter lhs: A pointwise value
    /// - Returns: Pointwise where all components have been negated.
    @_disfavoredOverload
    static prefix func - (lhs: Self) -> Self { lhs.pointwise(-) }
}
