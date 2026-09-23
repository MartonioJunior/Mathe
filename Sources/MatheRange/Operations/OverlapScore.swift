//
//  IntersectionScore.swift
//  Mathe
//
//  Created by Martônio Júnior on 23/09/2026.
//

/// Data structure that represents the overlap between two distinct boundaries.
public struct OverlapScore {
    /// How much does boundary A overlap boundary B?
    /// 
    /// Defines the type of overlap between two boundaries:
    /// - Negative values indicate there's no overlap
    /// - Positive values indicate an overlap
    /// - `0` indicates no overlap, with the shapes being tangent to one another.
    public var rawValue: Double
    // MARK: Initializers
    /// Creates a new overlap score.
    /// - Parameter rawValue: Percentage of how much does boundary A overlap boundary B.
    public init(rawValue: Double) {
        self.rawValue = (...1).ceil(rawValue)
    }
}

// MARK: DotSyntax
public extension OverlapScore {
    /// Boundary A is fully inside boundary B.
    static var inside: Self { .init(rawValue: 1) }
    /// Boundary A is tangentially outside boundary B.
    static var tangent: Self { .init(rawValue: 0) }
    /// Boundary A is outside B by a certain distance percentage.
    /// - Parameter percentage: Percentage representing the relation to the distance to the center.
    static func outside(_ percentage: Double = 1.0) -> Self {
        .init(rawValue: -abs(percentage))
    }
}

// MARK: Self: Comparable
extension OverlapScore: Comparable {
    // swiftlint:disable:next missing_docs
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: Self: Equatable
extension OverlapScore: Equatable {}

// MARK: Self: RawRepresentable
extension OverlapScore: RawRepresentable {}

// MARK: Self: Sendable
extension OverlapScore: Sendable {}
