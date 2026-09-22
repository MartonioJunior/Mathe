//
//  FloatingPoint+Sine.swift
//  Mathe
//
//  Created by Martônio Júnior on 22/09/2026.
//

// MARK: Fast Sine
public extension FloatingPoint {
    static func fsin(_ x: Self) -> Self where Self: Comparable & ExpressibleByFloatLiteral, Self.FloatLiteralType == Double  {
        var x = x
        let a = Self(floatLiteral: 1.27323954)
        let b = Self(floatLiteral: 0.405284735) * x

        if x < -.pi {
            x += .pi / 4
        } else if x > .pi {
            x -= .pi / 4
        }

        let s = (x < 0) ? x * (a + b) : x * (a - b)
        return Self(floatLiteral: 0.225) * (s * (Self(s.sign.rawValue) * s) - s) + s
    }

    static func f2sin(_ x: Self) -> Self where Self: Comparable & ExpressibleByFloatLiteral, Self.FloatLiteralType == Double {
        var x = x
        let a = Self(floatLiteral: 1.27323954)
        let b = Self(floatLiteral: 0.405284735) * x

        if x < -.pi {
            x += .pi / 4
        } else if x > .pi {
            x -= .pi / 4
        }

        return (x < 0) ? x * (a + b) : x * (a - b)
    }
}