//
//  Extent.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/04/2026.
//

/// Predicate-based boundary that defines an open range.
/// 
/// Different from `ClosedRange` and `Range`, this type does not require `Bound` to conform to `Comparable` to work.
public struct Extent<Bound> {
    // MARK: Variables
    // swiftlint:disable:next missing_docs
    public var lowerBound: Bound
    // swiftlint:disable:next missing_docs
    public var upperBound: Bound
    /// Predicate used to define whether a value belongs in the boundary.
    var boundPredicate: (Bound) -> Bool
    // MARK: Initializers
    /// Creates a new extent based on lower bound, upper bound and a predicate.
    /// - Parameters:
    ///   - lowerBound: Minimum possible value.
    ///   - upperBound: Maximum possible value.
    ///   - boundPredicate: Predicate for the type.
    public init(
        from lowerBound: Bound,
        to upperBound: Bound,
        boundPredicate: @escaping (Bound) -> Bool
    ) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.boundPredicate = boundPredicate
    }
}

// MARK: Self: Gamut
extension Extent: Gamut {
    // swiftlint:disable:next missing_docs
    public init(from lowerBound: Bound, to upperBound: Bound) {
        self.init(from: lowerBound, to: upperBound) { _ in false }
    }
    // swiftlint:disable:next missing_docs
    public static func ~= (lhs: Extent<Bound>, rhs: Bound) -> Bool {
        lhs.boundPredicate(rhs)
    }
}
