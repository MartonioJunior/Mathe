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

    func isInside<B: Boundary>(_ boundary: B) -> Bool where Bound == B.Bound {
        boundary.contains(lowerBound) && boundary.contains(upperBound)
    }

    func isOutside<B: Boundary>(_ boundary: B) -> Bool where Bound == B.Bound {
        boundary.isAbove(self) || boundary.isBelow(self)
    }

    func overlaps<B: Boundary>(_ boundary: B) -> Bool where Bound == B.Bound {
        !isOutside(boundary)
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

    func merge(with other: Self) -> Self {
        .init(from: min(lowerBound, other.lowerBound), to: max(upperBound, other.upperBound))
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

// MARK: Self.Bound: FloatingPoint
public extension Gamut where Bound: FloatingPoint {
    func inverseLerp(_ value: Bound) -> Bound {
        score(value, using: .inverseLinear)
    }

    func remap(_ value: Bound, to newRange: Self) -> Bound {
        remap(value, to: newRange, using: .init(.inverseLinear, interpolation: .linear))
    }
}

// MARK: Self.Bound: Numeric
public extension Gamut where Bound: Numeric {
    func crossFade(by t: Bound) -> Bound {
        interpolate(.crossFade, t: t)
    }

    func lerp(t: Bound) -> Bound {
        interpolate(.linear, t: t)
    }
}

// MARK: Self.Bound: SignedNumeric
public extension Gamut where Bound: SignedNumeric & Comparable {
    var magnitude: Bound { abs(distance) }
}

// MARK: Self.Bound: Strideable
public extension Gamut where Bound: Strideable {
    func adjacent(to other: Self) -> Bool {
        other ~= lowerBound.advanced(by: -1) || other ~= upperBound.advanced(by: 1)
    }

    func overlapsOrAdjacent(to other: Self) -> Bool {
        other.overlaps(Self(from: lowerBound.advanced(by: -1), to: upperBound.advanced(by: 1)))
    }

    func strideTo(by jump: Bound.Stride) -> StrideTo<Bound> {
        stride(from: lowerBound, to: upperBound, by: jump)
    }

    func strideThrough(by jump: Bound.Stride) -> StrideThrough<Bound> {
        stride(from: lowerBound, through: upperBound, by: jump)
    }
}

// MARK: Boundary (EX)
public extension Boundary {
    func envelops<G: Gamut>(_ gamut: G) -> Bool where Bound == G.Bound {
        gamut.isInside(self)
    }
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
