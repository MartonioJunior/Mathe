//
//  ElementaryFunctions+Utilities.swift
//  Core
//
//  Created by Martônio Júnior on 16/04/2025.
//

public import Numerics

public extension ElementaryFunctions {
    var negated: Self { .zero - self }

    func root(n exponent: Int) -> Self where Self: Comparable {
        let e = 1 / exponent
        let negativeNumber = self < Self.zero
        let isOddNumber = abs(exponent % 2) == 1

        return if negativeNumber && isOddNumber {
            self.negated.pow(e).negated
        } else {
            self.pow(e)
        }
    }
}

// MARK: Power
public extension ElementaryFunctions {
    // exp(y * log(x))
    func pow(_ exponent: Self) -> Self {
        Self.pow(self, exponent)
    }

    // x^n
    func pow(_ exponent: Int) -> Self {
        Self.pow(self, exponent)
    }
}
