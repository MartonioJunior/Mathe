//
//  Floor.swift
//  Mathe
//
//  Created by Martônio Júnior on 16/07/2025.
//

/// Topological mask that contains a lower bound.
public protocol Floor {
    associatedtype Bound
    /// Value representing the floor of the mask.
    /// 
    /// Usually, it is the minimum possible value accepted by the mask.
    var lowerBound: Bound { get }
}

// MARK: Self.Bound: Comparable
public extension Floor where Bound: Comparable {
    /// Returns the greater between the value passed and lower bound.
    /// - Parameter value: A value to compare.
    /// - Returns: The greater between `value` and `lowerBound`.
    func floor(_ value: Bound) -> Bound {
        max(value, lowerBound)
    }
    /// Distance of a value from the lower bound.
    /// - Parameter value: A target value.
    /// - Returns: The linear distance between `value` and `lowerBound`.
    /// 
    /// Any value lesser or equal to `lowerBound` is considered part of the floor
    /// and has distance `.zero`.
    func floorDistance(to value: Bound) -> Bound where Bound: AdditiveArithmetic {
        max(value - lowerBound, .zero)
    }
}

// MARK: Boundary (EX)
public extension Boundary {
    /// Checks when the boundary is before a given boundary's floor
    /// - Parameter floor: A boundary with a floor to compare to.
    /// - Returns:
    ///   - `true` when this boundary is before `floor`
    ///   - `false` when this boundary is after or aligned with `floor`
    func isBefore<F: Floor>(_ floor: F) -> Bool where Bound == F.Bound {
        !contains(floor.lowerBound)
    }
}

// MARK: PartialRangeFrom (EX)
extension PartialRangeFrom: Floor {}

public extension PartialRangeFrom where Bound: AdditiveArithmetic {
    /// Returns a `0...` range
    static var positive: Self { .init(.zero) }
}
