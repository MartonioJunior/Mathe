//
//  Real+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 29/04/2026.
//

#if Numerics
public import Numerics

public extension Real {
    static func arc(_ x: Self) -> Self {
        abs(.sin(x).saturated)
    }

    static func arch2(_ x: Self) -> Self {
        x * (1 - x)
    }

    static func pascalTriangle(row: Self, entry: Self) -> Self {
        stride(from: 0, to: row, by: 1).reduce(1) { $0 * (entry - $1) / ($1 + 1) }
    }

    static func sigmoid(_ x: Self) -> Self {
        1 / (1 + .exp(-x))
    }

    static func smootherStep(_ x: Self) -> Self {
        x.pow(3) * (x * (x * 6 - 15) + 10).saturated
    }

    static func smoothStepCos(_ x: Self) -> Self {
        (1 - .cos(x.saturated * .pi)) / 2
    }

    func smoothStart(_ n: Self) -> Self { .pow(self, n) }
    func smoothStop(_ n: Self) -> Self { 1 - .pow(1 - self, n) }

    func snap(step: Self) -> Self { (self / step).rounded() * step }
}

// MARK: Cosecant
public extension Real {
    // Cosecant
    static func csc(_ x: Self) -> Self {
        guard let reciprocal = x.reciprocal else { return .zero }

        return .sin(reciprocal)
    }

    /// Hyperbolic Tangent
    static func csch(_ x: Self) -> Self? {
        .sinh(x).reciprocal
    }

    // Arc Cosecant
    static func acsc(_ x: Self) -> Self? {
        guard let reciprocal = x.reciprocal else { return nil }

        return .csc(reciprocal)
    }

    // Hyperbolic Arc Cosecant
    static func acsch(_ x: Self) -> Self? {
        guard let reciprocal = x.reciprocal else { return nil }

        return .acosh(reciprocal)
    }
}

// MARK: Cotangent
public extension Real {
    /// Cotangent
    static func cot(_ x: Self) -> Self? {
        guard let reciprocal = x.reciprocal else { return nil }

        return .tan(reciprocal)
    }

    /// Hyperbolic Tangent
    static func coth(_ x: Self) -> Self? {
        .cosh(x).reciprocal
    }

    /// Arc Cotangent
    static func acot(_ x: Self) -> Self? {
        guard let reciprocal = x.reciprocal else { return nil }

        return .atan(reciprocal)
    }

    /// Hyperbolic Arc Cotangent
    static func acoth(_ x: Self) -> Self? {
        .log((x + 1) / (x - 1)) / 2
    }
}


// MARK: Self: ExpressibleByFloatLiteral
public extension Real where Self: ExpressibleByFloatLiteral, Self.FloatLiteralType == Double {
    /// https://gist.github.com/voidqk/fc5a58b7d9fc020ecf7f2f5fc907dfa5
    /// Computes atan2(y,x), fast -->  max err: 0.071115
    static func fastAtan2(y: Self, x: Self) -> Self {
        let quarterPi = Self.pi * 0.25
        let threeFourthsPi = Self.pi * 0.75

        if y == 0 && x == 0 { return 0 }

        let absY = abs(y)

        let angle = if x >= 0 {
            quarterPi - quarterPi * ((x - absY) / (x + absY))
        } else {
            threeFourthsPi - quarterPi * ((x + absY) / (absY - x))
        }

        return angle.changeSign(basedOn: y)
    }

    static func inverseSmoothStep(_ x: Self) -> Self {
        Self(floatLiteral: 0.5) - .sin(.asin(1 - 2 * x) / 3)
    }
}

// MARK: Saturated (EX)
public extension Saturated where Value: Real, Value.Stride: SignedNumeric {
    func smoothStep(_ n: Value) -> Value {
        stride(from: 0, to: n, by: 1).reduce(0) { acc, value in
            acc + .pascalTriangle(row: value, entry: -n - 1)
                * .pascalTriangle(row: n - value, entry: 2 * n + 1)
                * wrappedValue.pow(n + value + 1)
        }
    }
}
#endif
