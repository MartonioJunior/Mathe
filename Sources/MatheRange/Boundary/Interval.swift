//
//  Interval.swift
//  Mathe
//
//  Created by Martônio Júnior on 19/09/2026.
//

public struct Interval<Bound: Comparable> {
    /// Endpoint representing the ceiling (b).
    var ceiling: Endpoint
    /// Endpoint representing the floor (a).
    var floor: Endpoint
    /// Creates a new interval.
    /// - Parameters:
    ///   - floor: Endpoint representing the floor (a).
    ///   - ceiling: Endpoint representing the ceiling (b).
    public init(_ floor: Endpoint, _ ceiling: Endpoint) {
        self.ceiling = ceiling
        self.floor = floor
    }
}

// MARK: DotSyntax
public extension Interval {
    /// Creates an unbounded interval.
    /// 
    /// Also known as the universe set for type `T`.
    static var unbounded: Self { .init(.unbounded, .unbounded) }
    /// Creates a closed interval.
    /// - Parameters:
    ///   - floor: Value representing the inclusive floor.
    ///   - ceiling: Value representing the inclusive ceiling.
    static func closed(_ floor: Bound, _ ceiling: Bound) -> Self {
        .init(.closed(floor), .closed(ceiling))
    }
    /// Creates an Interval of a single inclusive value.
    /// - Parameter value: Value representing the inclusive floor and ceiling.
    static func degenerate(_ value: Bound) -> Self {
        .closed(value, value)
    }
    /// Creates an open interval.
    /// - Parameters:
    ///   - floor: Value representing the non-inclusive floor.
    ///   - ceiling: Value representing the non-inclusive ceiling.
    static func open(_ floor: Bound, _ ceiling: Bound) -> Self {
        .init(.open(floor), .open(ceiling))
    }
    /// Creates an Interval of a single non-inclusive value.
    /// - Parameter value: Value representing the non-inclusive floor and ceiling.
    static func unordered(_ value: Bound) -> Self {
        .open(value, value)
    }
}

// MARK: Self.Endpoint
public extension Interval {
    /// Data structure representing the behaviour of one point in the interval.
    enum Endpoint {
        /// End where the value is included in the boundary.
        case closed(Bound)
        /// End where the value is excluded from the boundary.
        case open(Bound)
        /// End extends infinitely.
        case unbounded
    }
}

// MARK: Self: Boundary
extension Interval: Boundary {
    private func ceilingContains(_ value: Bound) -> Bool {
        switch ceiling {
            case let .open(x): value < x
            case let .closed(x): value <= x
            case .unbounded: true
        }
    }

    private func floorContains(_ value: Bound) -> Bool {
        switch floor {
            case let .open(x): x < value
            case let .closed(x): x <= value
            case .unbounded: true
        }
    }
    // swiftlint:disable:next missing_docs
    public static func ~= (lhs: Self, rhs: Bound) -> Bool {
        lhs.floorContains(rhs) && lhs.ceilingContains(rhs)
    }
}
