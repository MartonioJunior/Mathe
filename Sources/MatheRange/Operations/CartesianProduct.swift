//
//  CartesianProduct.swift
//  Mathe
//
//  Created by Martônio Júnior on 19/09/2026.
//

public struct CartesianProduct<A: Boundary, B: Boundary> {
    var left: A
    var right: B

    public init(left: A, right: B) {
        self.left = left
        self.right = right
    }
}

// MARK: Self: Boundary
extension CartesianProduct: Boundary {
    public typealias Bound = (A.Bound, B.Bound)

    public static func ~= (lhs: Self, rhs: Bound) -> Bool {
        lhs.left.contains(rhs.0) && lhs.right.contains(rhs.1)
    }
}

// MARK: Self: SetOperation
extension CartesianProduct: BoundaryOperation {}

// MARK: Boundary (EX)
public extension Boundary {
    func cartesianProduct<Other: Boundary>(_ other: Other) -> CartesianProduct<Self, Other> {
        .init(left: self, right: other)
    }
}
