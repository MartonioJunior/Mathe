//
//  Floor.swift
//  Mathe
//
//  Created by Martônio Júnior on 16/07/2025.
//

public protocol Floor: Boundary {
    associatedtype Bound

    var lowerBound: Bound { get }
}

// MARK: Self.Bound: Comparable
public extension Floor where Bound: Comparable {
    func floor(_ value: Bound) -> Bound {
        max(value, lowerBound)
    }

    func distanceFromLowerBound(to value: Bound) -> Bound where Bound: AdditiveArithmetic {
        max(value - lowerBound, .zero)
    }
}

// MARK: PartialRangeFrom (EX)
extension PartialRangeFrom: Floor {}
