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
    /// Checks whether the gamut is entirely inside a given boundary.
    /// 
    /// To a gamut to be inside of a boundary, both it's upper and lower bounds have to be inside of it.
    /// - Parameter boundary: A boundary to compare to.
    /// - Returns: `true` when the gamut is inside of the boundary, `false` otherwise.
    func isInside<B: Boundary>(_ boundary: B) -> Bool where Bound == B.Bound {
        boundary.contains(lowerBound) && boundary.contains(upperBound)
    }
    /// Checks if the gamut is outside of a boundary.
    /// 
    /// To a gamut to be outside of a boundary, both it's upper and lower bounds have to be outside of it.
    /// - Parameter boundary: A boundary to compare to.
    /// - Returns: `true` when the gamut is outside of the boundary, `false` otherwise.
    func isOutside<B: Boundary>(_ boundary: B) -> Bool where Bound == B.Bound {
        boundary.isAbove(self) || boundary.isBelow(self)
    }
    /// Checks if there's any overlap between the gamut and the boundary.
    /// 
    /// To a gamut to be overlapping a boundary, either it's upper or lower bounds need to be inside of it.
    /// - Parameter boundary: A boundary to compare to.
    /// - Returns: `true` when the gamut is overlapping the boundary, `false` otherwise.
    func overlaps<B: Boundary>(_ boundary: B) -> Bool where Bound == B.Bound {
        !isOutside(boundary)
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
    /// Checks whether a gamut is adjacent to another.
    /// 
    /// For a gamut to be adjacent to another, it must contain either the `lowerBound`'s predecessor or `upperBound`'s successor.
    /// - Parameter other: Gamut to compare to.
    /// - Returns: `true` when the gamut is adjacent, `false` otherwise.
    func adjacent(to other: Self) -> Bool {
        other ~= lowerBound.advanced(by: -1) || other ~= upperBound.advanced(by: 1)
    }
    /// Checks whether a gamut is adjacent or overlaps with another gamut.
    /// - Parameter other: Gamut to compare to.
    /// - Returns: `true` when the gamut is adjacent or overlaps, `false` otherwise.
    func overlapsOrAdjacent(to other: Self) -> Bool {
        other.overlaps(Self(from: lowerBound.advanced(by: -1), to: upperBound.advanced(by: 1)))
    }
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

// MARK: Boundary (EX)
public extension Boundary {
    /// Checks whether a gamut is entirely within a boundary.
    /// 
    /// For a gamut to be inside of a boundary, both it's upper and lower bounds have to be inside of it.
    /// - Parameter gamut: Gamut to be compared to.
    /// - Returns: `true` when the boundary is inside the gamut, `false` otherwise.
    func envelops<G: Gamut>(_ gamut: G) -> Bool where Bound == G.Bound {
        gamut.isInside(self)
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
