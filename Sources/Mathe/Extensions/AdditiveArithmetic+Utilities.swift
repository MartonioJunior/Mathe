//
//  AdditiveArithmetic+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 19/01/2026.
//

// MARK: Self: Comparable
public extension AdditiveArithmetic where Self: Comparable {
    @_disfavoredOverload
    static func gcd(_ lhs: Self, _ rhs: Self) -> Self {
        if lhs == .zero || rhs == .zero { return .zero }

        var lhs = lhs
        var rhs = rhs

        while lhs != rhs {
            if lhs > rhs {
                lhs -= rhs
            } else {
                rhs -= lhs
            }
        }

        return lhs
    }
}
