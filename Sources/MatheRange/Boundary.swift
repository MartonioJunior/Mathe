//
//  Boundary.swift
//  Mathe
//
//  Created by Martônio Júnior on 20/10/2025.
//

/// Data structure that defines a discrete set of known values.
public protocol Boundary {
    /// Type that represents the types of values present in this boundary.
    associatedtype Bound

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
