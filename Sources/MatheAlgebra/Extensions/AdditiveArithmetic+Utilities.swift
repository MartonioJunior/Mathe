//
//  AdditiveArithmetic+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 19/01/2026.
//

public extension AdditiveArithmetic where Self: Comparable {
    /// Calculates the greatest common denominator between two numbers.
    /// - Parameters:
    ///   - lhs: A number.
    ///   - rhs: Another number.
    ///
    /// - Returns: Greatest common denominator of `lhs` and `rhs`.
    /// `.zero` when one of the numbers is also zero.
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

// MARK: Self: ExpressibleByIntegerLiteral
public extension AdditiveArithmetic where Self: ExpressibleByIntegerLiteral {
    /// 1 - x, for use in verbose expressions
    var flipped: Self { 1 - self }
}
