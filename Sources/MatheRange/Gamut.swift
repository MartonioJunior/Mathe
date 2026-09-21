//
//  Gamut.swift
//  Mathe
//
//  Created by Martônio Júnior on 16/07/2025.
//

/// Data structure that defines a continuous boundary with lower and upper bounds.
public protocol Gamut: Floor, Ceiling {
    /// Creates a new gamut from it's bounds.
    /// - Parameters:
    ///   - lowerBound: Lowest value for the boundary.
    ///   - upperBound: Highest value for the boundary.
    ///
    init(from lowerBound: Bound, to upperBound: Bound)
}

// MARK: Default Implementation
public extension Gamut {
    func reduceBounds<T>(_ reducer: (Bound, Bound) -> T) -> T {
        reducer(lowerBound, upperBound)
    }
}

// MARK: DotSyntax
public extension Gamut {
    /// Returns a gamut that has the same upper and lower bounds.
    /// - Parameter value: Minimum and maximum possible value.
    /// - Returns: A gamut that starts at `value` and ends in `value`.
    static func point(_ value: Bound) -> Self {
        .init(from: value, to: value)
    }
}

// MARK: Self.Bound: AdditiveArithmetic
public extension Gamut where Bound: AdditiveArithmetic {
    /// Distance value between `upperBound` and `lowerBound`
    var distance: Bound { upperBound - lowerBound }
    /// Sum of `upperBound` with `lowerBound`
    var sum: Bound { upperBound + lowerBound }
}

// MARK: Self.Bound: Comparable
public extension Gamut where Bound: Comparable {
    /// Limits value to be inside the gamut's bounds.
    /// - Parameter value: Value to be constrained.
    /// - Returns:
    ///   - `value` when value is inside of the gamut.
    ///   - `lowerBound` when the value is below the gamut.
    ///   - `upperBound` when the value is above the gamut.
    func clamp(_ value: Bound) -> Bound {
        floor(ceil(value))
    }
    /// Limits a gamut to be inside another.
    /// - Parameter limits: Gamut to be constrained to.
    /// - Returns: A new gamut that goes from the greater `lowerBound` to the lesser `upperBound`.
    func clamped(to limits: Self) -> Self {
        .init(from: max(lowerBound, limits.lowerBound), to: min(upperBound, limits.upperBound))
    }
    /// Combines a gamut with another, increasing it's boundary.
    /// - Parameter other: Gamut to be merged with.
    /// - Returns: A new gamut that goes from the lesser `lowerBound` to the greater `upperBound`.
    func merge(with other: Self) -> Self {
        .init(from: min(lowerBound, other.lowerBound), to: max(upperBound, other.upperBound))
    }
}

// MARK: Self: Comparable, Self.Bound: Strideable
public extension Gamut where Self: Comparable, Bound: Strideable {
    /// Retracts the gamut's lower bound by the specified amount
    /// - Parameter n: Offset for the lower bound
    /// - Returns: A new gamut that has `lowerBound` offset by `n`
    func debounce(by n: Bound.Stride) -> Self {
        .init(from: lowerBound.advanced(by: -n), to: upperBound)
    }
    /// Advances both of the gamut's bounds by the specified amount
    /// - Parameter n: Offset for the gamut
    /// - Returns: A new gamut that has both `lowerBound` and `upperBound` offset by `n`
    func move(by n: Bound.Stride) -> Self {
        .init(from: lowerBound.advanced(by: n), to: upperBound.advanced(by: n))
    }
    /// Advances the gamut's upper bound by the specified amount
    /// - Parameter n: Offset for the upper bound
    /// - Returns: A new gamut that has `upperBound` offset by `n`
    func throttle(by n: Bound.Stride) -> Self {
        .init(from: lowerBound, to: upperBound.advanced(by: n))
    }
}

// MARK: Self.Bound: Equatable
public extension Gamut where Bound: Equatable {
    /// Checks whether `lowerBound` is the same as `upperBound`
    var isShortCircuited: Bool { lowerBound == upperBound }
}

// MARK: Self.Bound: Numeric
public extension Gamut where Bound: Numeric {
    /// Product of `lowerBound` with `upperBound`
    var product: Bound { lowerBound * upperBound }
}

// MARK: Self.Bound: SignedNumeric
public extension Gamut where Bound: SignedNumeric & Comparable {
    /// Absolute distance between `upperBound` and `lowerBound`
    var magnitude: Bound { abs(distance) }
}

// MARK: Self.Bound: Strideable
public extension Gamut where Bound: Strideable {
    /// Creates a stride for this gamut.
    /// - Parameter jump: Value to be used for advancing the stride.
    /// - Returns: A `StrideTo` instance from `lowerBound` up to, but not including, `upperBound`.
    func strideTo(by jump: Bound.Stride) -> StrideTo<Bound> {
        stride(from: lowerBound, to: upperBound, by: jump)
    }
    /// Creates a stride for this gamut.
    /// - Parameter jump: Value to be used for advancing the stride.
    /// - Returns: A `StrideTo` instance from `lowerBound` to `upperBound`.
    func strideThrough(by jump: Bound.Stride) -> StrideThrough<Bound> {
        stride(from: lowerBound, through: upperBound, by: jump)
    }
}

// MARK: ClosedRange (EX)
extension ClosedRange: Gamut {
    /// Creates a new closed range that contains both of it's bounds
    /// - Parameters:
    ///   - lowerBound: Minimum possible value.
    ///   - upperBound: Maximum possible value.
    ///
    public init(from lowerBound: Bound, to upperBound: Bound) {
        self = lowerBound...upperBound
    }
}

// MARK: Range (EX)
extension Range: Gamut {
    /// Creates a new half-open range that contains it's lower bound, but not it's upper bound.
    /// - Parameters:
    ///   - lowerBound: Minimum possible value.
    ///   - upperBound: Maximum possible value.
    ///
    public init(from lowerBound: Bound, to upperBound: Bound) {
        self = lowerBound..<upperBound
    }
}
