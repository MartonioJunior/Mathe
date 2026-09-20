//
//  Intersection.swift
//  Mathe
//
//  Created by Martônio Júnior on 18/09/2026.
//

/// Data structure representing an intersection between two boundaries `A` and `B`.
public struct Intersection<A: Boundary, B: Boundary> where A.Bound == B.Bound {
    var left: A
    var right: B

    var swapped: Intersection<B, A> {
        .init(left: right, right: left)
    }

    public init(left: A, right: B) {
        self.left = left
        self.right = right
    }
}

// MARK: Self: Boundary
extension Intersection: Boundary {
    public typealias Bound = A.Bound

    public static func ~= (lhs: Self, rhs: Bound) -> Bool {
        lhs.left.contains(rhs) && lhs.right.contains(rhs)
    }
}

// MARK: Self: SetOperation
extension Intersection: BoundaryOperation {}

// MARK: Self.Bound: Comparable
public extension Intersection where Bound: Comparable {
    func isOverlap<T>(on path: (Self) -> T?) -> Bool {
        path(self) != nil
    }
}

// MARK: Boundary (EX)
public extension Boundary {
    func intersection<Other: Boundary>(_ other: Other) -> Intersection<Self, Other> {
        .init(left: self, right: other)
    }
}

public extension Boundary where Bound: Comparable {
    func overlaps<Other: Boundary, T>(
        _ other: Other,
        on path: (Intersection<Self, Other>) -> T?
    ) -> Bool where Bound == Other.Bound {
        intersection(other).isOverlap(on: path)
    }
}

// MARK: Outcomes
public extension Intersection where B == EmptyBoundary<A.Bound> {
    var empty: B { .init() }
}

public extension Intersection where B == UniverseBoundary<A.Bound> {
    var identity: A { left }
}

public extension Intersection {
    var asSetDifference: SetDifference<A, SetDifference<A, B>> {
        .init(left: left, right: .init(left: left, right: right))
    }
}

public extension Intersection where A: Ceiling, B: Ceiling, Bound: Comparable {
    var rightOpenInterval: Interval<Bound> {
        .init(.unbounded, .open(max(left.upperBound, right.upperBound)))
    }
}

public extension Intersection where A == B, A: Ceiling, Bound: Comparable {
    var ceiling: A {
        left.upperBound < right.upperBound ? right : left
    }
}

public extension Intersection where A: Floor, B == PartialRangeThrough<Bound>, Bound: Comparable {
    var closedRange: ClosedRange<Bound>? {
        guard left.lowerBound <= right.upperBound else { return nil }

        return .init(from: left.lowerBound, to: right.upperBound)
    }
}

public extension Intersection where A: Floor, B: Gamut, Bound: Comparable {
    var gamut: B? {
        if left.lowerBound > right.upperBound { return nil }

        return if right.contains(left.lowerBound) {
            .init(from: left.lowerBound, to: right.upperBound)
        } else {
            right
        }
    }
}

public extension Intersection where A: Floor, B == PartialRangeUpTo<Bound>, Bound: Comparable {
    var range: Range<Bound>? {
        guard left.lowerBound <= right.upperBound else { return nil }

        return .init(from: left.lowerBound, to: right.upperBound)
    }
}

public extension Intersection where A: Floor, B: Floor, Bound: Comparable {
    var leftOpenInterval: Interval<Bound> {
        .init(.open(min(left.lowerBound, right.lowerBound)), .unbounded)
    }
}

public extension Intersection where A == B, A: Floor, Bound: Comparable {
    var floor: A {
        left.lowerBound < right.lowerBound ? right : left
    }
}
