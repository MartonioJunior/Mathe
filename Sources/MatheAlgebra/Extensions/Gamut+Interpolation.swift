//
//  Gamut+Interpolation.swift
//  Mathe
//
//  Created by Martônio Júnior on 22/09/2026.
//

public import MatheRange

// MARK: Self.Bound: FloatingPoint
public extension Gamut where Bound: FloatingPoint {
    /// Interpolation weight of a value for a given gamut.
    /// 
    /// Also known as a normalized linear interpolation.
    func inverseLerp(_ value: Bound) -> Bound {
        if isShortCircuited { return .zero }

        return (value - lowerBound) / distance
    }

    func linearAngle(_ x: Saturated<Bound>) -> Bound {
        var num = distance.truncatingRemainder(dividingBy: 360)
        if num > 180 { num -= 360 }
        return lowerBound + num * x.wrappedValue
    }

    func linearStep(_ value: Bound) -> Bound {
        inverseLerp(value).rounded(.down)
    }

    func remap<G: Gamut>(_ value: Bound, to gamut: G) -> Bound where Bound == G.Bound {
        lerp(t: inverseLerp(value))
    }
}

// MARK: Self.Bound: Numeric
public extension Gamut where Bound: Numeric {
    /// Also works as a function for mixing between bounds
    func crossFade(t: Bound) -> Bound {
        t * upperBound + (1 - t) * lowerBound
    }

    func lerp(t: Bound) -> Bound {
        distance * t + lowerBound
    }
}

// MARK: Self.Bound: SignedNumeric
public extension Gamut where Bound: SignedNumeric {
    func crossFadeSigned(t: Bound) -> Bound {
        t * upperBound + (-t * lowerBound + lowerBound)
    }
}

// MARK: Numerics (Trait)
#if Numerics
public import MatheSIMD
public import Numerics

public extension Gamut where Bound: Numeric & ElementaryFunctions {
    func linearPow(_ n: Bound) -> Bound {
        lowerBound.pow(1 - n) * upperBound.pow(n)
    }
}

public extension Gamut where Bound: Pointwise, Bound.Scalar: ElementaryFunctions & AlgebraicField & Comparable & ExpressibleByFloatLiteral {
    @available(macOS 26, *)
    func sphericalLerp(t: Bound.Scalar) -> Bound {
        var target = upperBound
        var dotProduct = lowerBound.dot(target)

        if dotProduct < 0 {
            dotProduct = -dotProduct
            target = -target
        }

        guard dotProduct > 0.9995 else {
            return lowerBound.pointwise(upperBound) {
                Extent(from: $0, to: $1).lerp(t: t)
            }
        }

        let angle = Bound.Scalar.acos(dotProduct)
        let s = 1 / Bound.Scalar.sqrt(1 - dotProduct * dotProduct)
        let w1 = Bound.Scalar.sin(angle * (1 - t)) * s
        let w2 = Bound.Scalar.sin(angle * t) * s
        return (lowerBound * w1) .+ (upperBound * w2)
    }
}

public extension Gamut where Bound: Real {
    func inverseLinearPow(_ n: Bound) -> Bound {
        .log(lowerBound / n) / .log(lowerBound / upperBound)
    }
}
#endif
