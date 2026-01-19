//
//  Gamut.swift
//  Mathe
//
//  Created by Martônio Júnior on 16/07/2025.
//

public protocol Gamut: Floor, Ceiling {
    init(from lowerBound: Bound, to upperBound: Bound)
}

// MARK: Default Implementation
public extension Gamut {
    static func point(_ value: Bound) -> Self {
        .init(from: value, to: value)
    }
}

// MARK: Self.Bound: AdditiveArithmetic
public extension Gamut where Bound: AdditiveArithmetic {
    var distance: Bound { upperBound - lowerBound }
    var sum: Bound { upperBound + lowerBound }
}

// MARK: Self.Bound: Comparable
public extension Gamut where Bound: Comparable {
    func clamp(_ value: Bound) -> Bound {
        floor(ceil(value))
    }

    func clamped(to limits: Self) -> Self {
        .init(from: max(lowerBound, limits.lowerBound), to: min(upperBound, limits.upperBound))
    }
}

// MARK: Self: Comparable, Self.Bound: Strideable
public extension Gamut where Self: Comparable, Bound: Strideable {
    /// Retracts the gamut's lowerBound by the specified amount
    func debounce(by n: Bound.Stride) -> Self {
        .init(from: lowerBound.advanced(by: -n), to: upperBound)
    }
    /// Advances both of the gamut's bounds by the specified amount
    func move(by n: Bound.Stride) -> Self {
        .init(from: lowerBound.advanced(by: n), to: upperBound.advanced(by: n))
    }
    /// Advances the gamut's upperBound by the specified amount
    func throttle(by n: Bound.Stride) -> Self {
        .init(from: lowerBound, to: upperBound.advanced(by: n))
    }
}

// MARK: Self.Bound: Equatable
public extension Gamut where Bound: Equatable {
    var isShortCircuited: Bool { lowerBound == upperBound }
}

// MARK: Self.Bound: SignedNumeric
public extension Gamut where Bound: SignedNumeric & Comparable {
    var magnitude: Bound { abs(distance) }
}

// MARK: ClosedRange (EX)
extension ClosedRange: Gamut {
    public init(from lowerBound: Bound, to upperBound: Bound) {
        self = lowerBound...upperBound
    }
}

// MARK: Range (EX)
extension Range: Gamut {
    public init(from lowerBound: Bound, to upperBound: Bound) {
        self = lowerBound..<upperBound
    }
}
