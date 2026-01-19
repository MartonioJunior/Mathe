//
//  Ceiling.swift
//  Mathe
//
//  Created by Martônio Júnior on 16/07/2025.
//

public protocol Ceiling: Boundary {
    associatedtype Bound

    var upperBound: Bound { get }
}

// MARK: Self.Bound: Comparable
public extension Ceiling where Bound: Comparable {
    func ceil(_ value: Bound) -> Bound {
        min(value, upperBound)
    }

    func distanceToUpperBound(from value: Bound) -> Bound where Bound: AdditiveArithmetic {
        max(upperBound - value, .zero)
    }
}

// MARK: Boundary (EX)
public extension Boundary {
    func isAbove<C: Ceiling>(_ ceiling: C) -> Bool where Bound == C.Bound {
        !contains(ceiling.upperBound)
    }
}

// MARK: PartialRangeThrough (EX)
extension PartialRangeThrough: Ceiling {}

// MARK: PartialRangeUpTo (EX)
extension PartialRangeUpTo: Ceiling {}
