//
//  Ceiling.swift
//  Mathe
//
//  Created by Martônio Júnior on 16/07/2025.
//

/// Defines the upper bound for an element
public protocol Ceiling: Boundary {
    // swiftlint:disable:next missing_docs
    associatedtype Bound
    /// The maximum possible value for this element.
    var upperBound: Bound { get }
}

// MARK: Self.Bound: Comparable
public extension Ceiling where Bound: Comparable {
    /// Returns the lesser between the value passed and upper bound.
    /// 
    /// This constrains the value to stay within the ceiling's boundary.
    /// - Parameter value: A value to compare.
    /// - Returns: The lesser of `value` and `upperBound`.
    func ceil(_ value: Bound) -> Bound {
        min(value, upperBound)
    }
    /// Obtains the distance of a value in relation to the upper bound.
    /// - Parameter value: A target value.
    /// - Returns: The linear distance between `value` and `upperBound`.
    ///   If the value is greater or equal to `upperBound`, returns `.zero`
    func distanceToUpperBound(from value: Bound) -> Bound where Bound: AdditiveArithmetic {
        max(upperBound - value, .zero)
    }
}

// MARK: Boundary (EX)
public extension Boundary {
    /// Checks whether this boundary is above a given boundary's ceiling.
    /// - Parameter ceiling: A boundary with a ceiling to compare to.
    /// - Returns:
    ///   - `true` when this boundary is above `ceiling`.
    ///   - `false` when this boundary is below or aligned with `ceiling`.
    func isAbove<C: Ceiling>(_ ceiling: C) -> Bool where Bound == C.Bound {
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
