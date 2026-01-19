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
    func distanceFromLowerBound(to value: Bound) -> Bound where Bound: AdditiveArithmetic {
        max(value - lowerBound, .zero)
    }

    func floor(_ value: Bound) -> Bound {
        max(value, lowerBound)
    }
}

// MARK: Boundary (EX)
public extension Boundary {
    func isBelow<F: Floor>(_ floor: F) -> Bool where Bound == F.Bound {
        !contains(floor.lowerBound)
    }
}

// MARK: PartialRangeFrom (EX)
extension PartialRangeFrom: Floor {}
