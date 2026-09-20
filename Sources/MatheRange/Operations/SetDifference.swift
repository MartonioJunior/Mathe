//
//  SetDifference.swift
//  Mathe
//
//  Created by Martônio Júnior on 19/09/2026.
//

/// Data structure representing the difference between boundaries `A` and `B`.
public struct SetDifference<A: Boundary, B: Boundary> where A.Bound == B.Bound {
    var left: A
    var right: B

    public init(left: A, right: B) {
        self.left = left
        self.right = right
    }
}

// MARK: Self: Boundary
extension SetDifference: Boundary {
    public typealias Bound = A.Bound

    public static func ~= (lhs: Self, rhs: Bound) -> Bool {
        lhs.left.contains(rhs) && !lhs.right.contains(rhs)
    }
}

// MARK: Self: SetOperation
extension SetDifference: BoundaryOperation {}

// MARK: Self.A: Equatable
public extension SetDifference where A: Equatable, Bound: Comparable {
    func isInside(on path: (Self) -> A?) -> Bool {
        path(self) == nil
    }

    func isOutside(on path: (Self) -> A?) -> Bool {
        path(self) == left
    }
}

// MARK: Boundary (EX)
public extension Boundary {
    func difference<Other: Boundary>(_ other: Other) -> SetDifference<Self, Other> {
        .init(left: self, right: other)
    }
}

public extension Boundary where Self: Equatable, Bound: Comparable {
    func isInside<Other: Boundary>(
        _ other: Other,
        on path: (SetDifference<Self, Other>) -> Self?
    ) -> Bool where Bound == Other.Bound {
        difference(other).isInside(on: path)
    }

    func isOutside<Other: Boundary>(
        _ other: Other,
        on path: (SetDifference<Self, Other>) -> Self?
    ) -> Bool where Bound == Other.Bound {
        difference(other).isOutside(on: path)
    }
}
