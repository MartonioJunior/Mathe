//
//  Boundary.swift
//  Mathe
//
//  Created by Martônio Júnior on 20/10/2025.
//

/// Data structure that defines a topological mask for a discrete set of known values.
///
/// Provides an alternative to `RangeExpression` where `Bound` does not need to be `Comparable`.
public protocol Boundary<Bound> {
    /// Type that represents the types of values present in the set.
    associatedtype Bound
    // MARK: Operators
    /// Checks whether a value exists inside of the boundary.
    /// - Parameters:
    ///   - lhs: Boundary used as the reference.
    ///   - rhs: A value to be checked.
    ///
    /// - Returns: `true` when the value exists within the boundary, `false` otherwise.
    static func ~= (lhs: Self, rhs: Bound) -> Bool
}

// MARK: Default Implementation
public extension Boundary {
    /// Checks whether a value exists inside of the boundary.
    /// - Parameters:
    ///   - lhs: Boundary used as the reference.
    ///   - rhs: A value to be checked.
    ///
    /// - Returns: `true` when the value exists within the boundary, `false` otherwise.
    func contains(_ bound: Bound) -> Bool { self ~= bound }
}

// MARK: ClosedRange (EX)
extension ClosedRange: Boundary {}

// MARK: PartialRangeFrom (EX)
extension PartialRangeFrom: Boundary {}

// MARK: PartialRangeThrough (EX)
extension PartialRangeThrough: Boundary {}

// MARK: PartialRangeUpTo (EX)
extension PartialRangeUpTo: Boundary {}

// MARK: Range (EX)
extension Range: Boundary {}
