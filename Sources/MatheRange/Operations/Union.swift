//
//  Union.swift
//  Mathe
//
//  Created by Martônio Júnior on 19/09/2026.
//

public struct Union<A: Boundary, B: Boundary> where A.Bound == B.Bound {
    var left: A
    var right: B

    var swapped: Union<B, A> {
        .init(left: right, right: left)
    }

    public init(left: A, right: B) {
        self.left = left
        self.right = right
    }
}

// MARK: Self: Boundary
extension Union: Boundary {
    public typealias Bound = A.Bound

    public static func ~= (lhs: Self, rhs: Bound) -> Bool {
        lhs.left.contains(rhs) || lhs.right.contains(rhs)
    }
}

// MARK: Self: SetOperation
extension Union: BoundaryOperation {}

// MARK: Self.A: Equatable
public extension Union where A: Equatable {
    func isSuperset(on path: (Self) -> A) -> Bool {
        path(self) == left
    }
}

// MARK: Self.B: Equatable
public extension Union where B: Equatable {
    func isSubset(on path: (Self) -> B) -> Bool {
        path(self) == right
    }
}

// MARK: Boundary (EX)
public extension Boundary {
    func isSubset<Other: Boundary & Equatable>(
        of other: Other,
        on path: (Union<Self, Other>) -> Other
    ) -> Bool where Bound == Other.Bound {
        union(other).isSubset(on: path)
    }

    func isStrictSubset<Other: Boundary & Equatable, T>(
        of other: Other,
        on pathA: (Union<Self, Other>) -> Other,
        _ pathB: (SetDifference<Self, Other>) -> T?
    ) -> Bool where Bound == Other.Bound {
        isSubset(of: other, on: pathA) && pathB(difference(other)) != nil
    }

    func union<Other: Boundary>(_ other: Other) -> Union<Self, Other> {
        .init(left: self, right: other)
    }
}

public extension Boundary where Self: Equatable {
    func isSuperset<Other: Boundary>(
        of other: Other,
        on path: (Union<Self, Other>) -> Self
    ) -> Bool where Bound == Other.Bound {
        union(other).isSuperset(on: path)
    }

    func isStrictSuperset<Other: Boundary, T>(
        of other: Other,
        on pathA: (Union<Self, Other>) -> Self,
        _ pathB: (SetDifference<Self, Other>) -> T?
    ) -> Bool where Bound == Other.Bound {
        isSuperset(of: other, on: pathA) && pathB(difference(other)) != nil
    }
}

// MARK: Outcomes
public extension Union where B == EmptyBoundary<A.Bound> {
    var identity: A { left }
}

public extension Union where B == UniverseBoundary<A.Bound> {
    var universe: B { .init() }
}
