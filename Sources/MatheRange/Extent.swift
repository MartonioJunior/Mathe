//
//  Extent.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/04/2026.
//

/// Gamut that encircles one or more values, independent of bounds order.
/// 
/// Different from `ClosedRange` and `Range`, this type does not require `Bound` to conform to `Comparable` to be used
/// or that it's upper bound is greater or equal than it's lower bound.
public struct Extent<Bound> {
    // MARK: Variables
    /// Start of the extent.
    public var lowerBound: Bound
    /// End of the extent.
    public var upperBound: Bound
    // MARK: Initializers
    /// Creates a new extent based on lower and upper bounds.
    /// - Parameters:
    ///   - lowerBound: Minimum possible value.
    ///   - upperBound: Maximum possible value.
    public init(
        from lowerBound: Bound,
        to upperBound: Bound
    ) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }
}

// MARK: Self: Gamut
extension Extent: Gamut {}

// MARK: Self.Bound: Comparable
public extension Extent where Bound: Comparable {
    /// Closed range represented by the extent.
    /// 
    /// Automatically corrects values to be in order.
    var range: ClosedRange<Bound> {
        if lowerBound < upperBound {
            lowerBound...upperBound
        } else {
            upperBound...lowerBound
        }
    }
}
