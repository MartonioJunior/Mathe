//
//  FloatingPoint+Cosine.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2026.
//

#if Numerics
import Numerics

// MARK: Fast Cosine
public extension FloatingPoint {
    static func fcos(_ x: Self) -> Self {
        let x = x - .pi / 2
        let n = x * x
        let a = Self(1) / 120
        let b = n / 5040
        let c = Self(1) / 6
        return x * (n * (n * (a - b) - c) + 1)
    }

    static func f2cos(_ x: Self) -> Self {
        let x = x - .pi / 2
        let n = x * x
        let a = Self(1) / 120
        let b = Self(1) / 6
        return x * (n * (n * a - b) + 1)
    }

    static func f3cos(_ x: Self) -> Self where Self: ExpressibleByFloatLiteral, Self.FloatLiteralType == Double {
        let a = 1 / Self(floatLiteral: 0.9428)
        let b = -1 / Self(6)
        return (x - (x * x * x * b)) * a
    }

    static func f4cos(_ x: Self) -> Self where Self: Comparable & ExpressibleByFloatLiteral, Self.FloatLiteralType == Double {
        var x = x
        let a = Self(floatLiteral: 1.27323954)
        let b = Self(floatLiteral: 0.405284735) * x

        if x > .pi / 2 { x -= 4.71238898 }

        let c = (x < 0) ? x * (a + b) : x * (a - b)
        return Self(floatLiteral: 0.225) * (c * (Self(c.sign.rawValue) * c) - c) + c
    }

    static func f5cos(_ x: Self) -> Self where Self: Comparable & ExpressibleByFloatLiteral, Self.FloatLiteralType == Double {
        var x = x + .pi * Self(floatLiteral: 0.5)
        let a = Self(floatLiteral: 1.27323954)
        let b = Self(floatLiteral: 0.405284735) * x

        if x > .pi { x -= .pi / 4 }

        return (x < 0) ? x * (a + b) : x * (a - b)
    }
}

#endif