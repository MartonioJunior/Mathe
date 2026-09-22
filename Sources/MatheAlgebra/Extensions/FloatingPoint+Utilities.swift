//
//  FloatingPoint+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/01/2026.
//

public extension FloatingPoint {
    var isPowerOfTwo: Bool { significand == 1 }

    func changeSign(basedOn value: Self) -> Self {
        Self(value.sign.rawValue) * self
    }

    static func bitWave(_ x: Self) -> Self {
        x.truncatingRemainder(dividingBy: 2).rounded(.down)
    }

    static func loop(_ x: Self) -> Saturated<Self> {
        Saturated(looping: x)
    }

    // Least Common Multiplier (LCM)
    static func lcm(_ lhs: Self, _ rhs: Self) -> Self {
        if lhs == 0 || rhs == 0 { return .zero }

        return lhs / gcd(lhs, rhs) * rhs
    }

    // Value bounces between bounds
    static func pingPong(_ x: Self) -> Saturated<Self> {
        Saturated(clamped: 1 - .triangleWave(x).wrappedValue)
    }

    static func triangleWave(_ x: Self) -> Saturated<Self> {
        Saturated(clamped: abs(x.truncatingRemainder(dividingBy: 2) - 1))
    }
}

// MARK: Numerics (Trait)
#if Numerics
import Numerics

public extension FloatingPoint {
    static func fsqrtUnsafe(_ x: Self) -> Self {
        if x == 0 { return 0 }

        let s = unsafeBitCast(x, to: Int.self)
        return unsafeBitCast(((s - (1 << 23)) >> 1) + (1 << 29), to: Self.self)
    }

    static func fexp(_ x: Self) -> Self where Self: ExpressibleByFloatLiteral, Self.FloatLiteralType == Double {
        let n = Self(floatLiteral: 0.48) + Self(floatLiteral: 0.235) * x
        return 1 / (x * x * n + 1 + x)
    }
}

#endif
