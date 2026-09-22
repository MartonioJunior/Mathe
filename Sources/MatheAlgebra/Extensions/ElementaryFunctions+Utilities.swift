//
//  ElementaryFunctions+Utilities.swift
//  Core
//
//  Created by Martônio Júnior on 16/04/2025.
//

#if Numerics
public import Numerics

public extension ElementaryFunctions {
    /// Used mostly for chaining negative associations
    var negated: Self { .zero - self }

    // exp(y * log(x))
    func pow(_ exponent: Self) -> Self {
        Self.pow(self, exponent)
    }

    // x^n
    func pow(_ exponent: Int) -> Self {
        Self.pow(self, exponent)
    }

    func root(n exponent: Int) -> Self where Self: Comparable {
        let e = 1 / exponent
        let negativeNumber = self < Self.zero

        return if negativeNumber && exponent.isOdd {
            self.negated.pow(e).negated
        } else {
            self.pow(e)
        }
    }
}

// MARK: Self: AlgebraicField
public extension ElementaryFunctions where Self: AlgebraicField {
    // Cosine Squared
    static func cos2(_ x: Self) -> Self {
        (1 + .cos(2 * x)) / 2
    }
    // Sine Squared
    static func sin2(_ x: Self) -> Self {
        (1 - .cos(2 * x)) / 2
    }
    /// Tangent Squared
    static func tan2(_ x: Self) -> Self {
        let n = cos(2 * x)
        return (1 - n) * (1 + n)
    }
}
#endif
