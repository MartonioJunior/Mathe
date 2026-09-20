//
//  Ceiling.swift
//  Mathe
//
//  Created by Martônio Júnior on 16/07/2025.
//

/// Topological mask that contains an upper bound
public protocol Ceiling {
    // swiftlint:disable:next missing_docs
    associatedtype Bound
    /// Value representing the ceiling of the mask.
    /// 
    /// Usually, it is the maximum possible value accepted by the mask.
    var upperBound: Bound { get }
}

// MARK: Self.Bound: Comparable
public extension Ceiling where Bound: Comparable {
    /// Returns the lesser between the value passed and upper bound.
    /// - Parameter value: A value to compare.
    /// - Returns: The lesser of `value` and `upperBound`.
    func ceil(_ value: Bound) -> Bound {
        min(value, upperBound)
    }
    /// Distance of a value to the upper bound.
    /// - Parameter value: A target value.
    /// - Returns: The linear distance between `value` and `upperBound`.
    /// 
    /// Any value greater or equal to `upperBound` is considered part of the ceiling
    /// and has distance
    ///   If the value is greater or equal to `upperBound`, returns `.zero`
    func ceilDistance(from value: Bound) -> Bound where Bound: AdditiveArithmetic {
        max(upperBound - value, .zero)
    }
}

// MARK: Boundary (EX)
public extension Boundary {
    /// Checks whether this boundary is after a given boundary's ceiling.
    /// - Parameter ceiling: A boundary with a ceiling to compare to.
    /// - Returns:
    ///   - `true` when this boundary is after `ceiling`.
    ///   - `false` when this boundary is before or aligned with `ceiling`.
    func isAfter<C: Ceiling>(_ ceiling: C) -> Bool where Bound == C.Bound {
        !contains(ceiling.upperBound)
    }
}

// MARK: PartialRangeThrough (EX)
extension PartialRangeThrough: Ceiling {}

// MARK: PartialRangeUpTo (EX)
extension PartialRangeUpTo: Ceiling {}

public extension PartialRangeUpTo where Bound: AdditiveArithmetic {
    /// Returns a `..<0` range
    static var negative: Self { .init(.zero) }
}
