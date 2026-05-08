//
//  Floor.swift
//  Mathe
//
//  Created by Martônio Júnior on 16/07/2025.
//

/// Defines the lower bound for an element.
public protocol Floor: Boundary {
    /// swiftlint:disable:next missing_docs
    associatedtype Bound
    /// The minimum possible value for this boundary
    var lowerBound: Bound { get }
}

// MARK: Self.Bound: Comparable
public extension Floor where Bound: Comparable {
    /// Returns the distance of a value from the lower bound.
    /// - Parameter value: A target value.
    /// - Returns: The linear distance between `value` and `lowerBound`.
    ///   If the value is lesser or equal to `lowerBound`, returns `.zero`.
    func distanceFromLowerBound(to value: Bound) -> Bound where Bound: AdditiveArithmetic {
        max(value - lowerBound, .zero)
    }
    /// Returns the greater between the value passed and lower bound.
    /// - Parameter value: A value to compare.
    /// - Returns: The greater between `value` and `lowerBound`.
    func floor(_ value: Bound) -> Bound {
        max(value, lowerBound)
    }
}

// MARK: Boundary (EX)
public extension Boundary {
    /// Checks when the boundary is below a given boundary's floor
    /// - Parameter floor: A boundary with a floor to compare to.
    /// - Returns:
    ///   - `true` when this boundary is below `floor`
    ///   - `false` when this boundary is above or aligned with `floor`
    func isBelow<F: Floor>(_ floor: F) -> Bool where Bound == F.Bound {
        !contains(floor.lowerBound)
    }
}

// MARK: PartialRangeFrom (EX)
extension PartialRangeFrom: Floor {}

public extension PartialRangeFrom where Bound: AdditiveArithmetic {
    /// Returns a `0...` range
    static var positive: Self { .init(.zero) }
}
