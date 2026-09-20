//
//  SymmetricDifference.swift
//  Mathe
//
//  Created by Martônio Júnior on 19/09/2026.
//

public struct SymmetricDifference<A: Boundary, B: Boundary> where A.Bound == B.Bound {
    var left: A
    var right: B

    var swapped: SymmetricDifference<B, A> {
        .init(left: right, right: left)
    }

    public init(left: A, right: B) {
        self.left = left
        self.right = right
    }
}

// MARK: Self: Boundary
extension SymmetricDifference: Boundary {
    public typealias Bound = A.Bound

    public static func ~= (lhs: Self, rhs: Bound) -> Bool {
        let containsLeft = lhs.left.contains(rhs)
        let containsRight = lhs.right.contains(rhs)

        return (containsLeft && !containsRight) || (!containsLeft && containsRight)
    }
}

// MARK: Self: SetOperation
extension SymmetricDifference: BoundaryOperation {}

// MARK: Boundary (EX)
public extension Boundary {
    func symmetricDifference<Other: Boundary>(_ other: Other) -> SymmetricDifference<Self, Other> {
        .init(left: self, right: other)
    }
}
