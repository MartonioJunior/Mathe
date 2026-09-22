//
//  Real+Secant.swift
//  Mathe
//
//  Created by Martônio Júnior on 04/05/2026.
//

#if Numerics
public import Numerics

public extension Real {
    /// Secant
    static func sec(_ x: Self) -> Self? {
        guard let reciprocal = x.reciprocal else { return nil }

        return .cos(reciprocal)
    }

    /// Secant Squared
    static func sec2(_ x: Self) -> Self? where Self: ExpressibleByFloatLiteral, Self.FloatLiteralType == Double {
        .cos2(x).reciprocal
    }

    /// Hyperbolic Secant
    static func sech(_ x: Self) -> Self? {
        .cosh(x).reciprocal
    }

    /// Arc Secant
    static func asec(_ x: Self) -> Self? {
        guard let reciprocal = x.reciprocal else { return nil }

        return .sec(reciprocal)
    }

    /// Hyperbolic Arc Secant
    static func asech(_ x: Self) -> Self? {
        guard let reciprocal = x.reciprocal else { return nil }

        return .acosh(reciprocal)
    }
}
#endif
