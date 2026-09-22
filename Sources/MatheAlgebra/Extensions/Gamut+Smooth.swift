//
//  SmoothStep.swift
//  Mathe
//
//  Created by Martônio Júnior on 03/05/2026.
//

#if Numerics
public import MatheRange
import MatheSIMD
public import Numerics

// MARK: Self.Bound: AlgebraicField
public extension Gamut where Bound: AlgebraicField & ElementaryFunctions & Comparable {
    func smoothMin(_ n: Bound = 2, t: Bound, factor: inout Bound) -> Bound {
        let h = max(t - abs(lowerBound - upperBound), 0) / t
        let m = h.pow(n) / 2
        let s = m * t / n

        if lowerBound < upperBound {
            factor = m
            return lowerBound - s
        }

        factor = 1 - m
        return upperBound - s
    }
}

// MARK: Self.Bound: Real
public extension Gamut where Bound: Real {
    @available(macOS 26.0, *)
    func smoothMaxExponential(_ value: Bound) -> Bound {
        let n = (Vector<2, Bound>([-distance, distance]) / value).pointwise(Bound.exp)
        return Vector<2, Bound>([lowerBound, upperBound]).dot(n) / n.componentSum
    }

    // Smooth Min Functions https://iquilezles.org/articles/smin/
    func smoothMinExponential(_ value: Bound) -> Bound {
        let n = Bound.exp2(-value * lowerBound) + .exp2(-value * upperBound)
        return .log2(-n) / value
    }

    func smoothMinPow(_ value: Bound) -> Bound {
        let a = lowerBound.pow(value)
        let b = upperBound.pow(value)
        return (a * b / (a + b)).pow(value.reciprocal ?? 1)
    }

    func smoothMinCubic(_ value: Bound) -> Bound {
        let n = max(value - abs(lowerBound - upperBound), 0) / value
        return min(lowerBound, upperBound) - n.pow(3) * value / 6
    }
}

public extension Gamut where Bound: Real & ExpressibleByFloatLiteral {
    func smoothDamp(_ velocity: inout Bound, smoothTime: Bound, maxSpeed: Bound, deltaTime: Bound) -> Bound {
        let smoothTime = max(smoothTime, 0.0001)
        let omega = 2 / smoothTime
        var result: Bound

        let x = omega * deltaTime
        let value = x * (x * (0.48 + x * 0.235) + 1)

        let clampedDistance = -distance.clampMagnitude(maxSpeed * smoothTime)

        let temp = (velocity + omega * clampedDistance) * deltaTime
        let f = value.bestDivideFunction

        velocity = f(velocity - omega * temp)
        result = lowerBound - clampedDistance + f(clampedDistance + temp)

        if (distance) * (result - upperBound) <= 0 { return result }

        result = upperBound
        velocity = 0

        return result
    }
}

public extension Gamut where Bound: Real & ExpressibleByFloatLiteral, Bound.FloatLiteralType == Double {
    func smoothMax(_ value: Bound) -> Bound {
        let h = Bound(floatLiteral: 0.5) + distance / (value * 2).saturated
        return lerp(t: h) + value * h * (1 - h)
    }

    func smoothMin(_ value: Bound) -> Bound {
        smoothMax(-value)
    }

    func smoothMinRoot(_ value: Bound) -> Bound {
        let n = lowerBound - upperBound
        return Bound(floatLiteral: 0.5) * (sum - .sqrt(n * n * value))
    }

    func smoothMinPolynomial(_ value: Bound) -> Bound {
        let n = (Bound(floatLiteral: 0.5) + distance) / (value * 2).saturated
        return Extent(from: upperBound, to: lowerBound).lerp(t: n) - value * n * (1 - n)
    }

    func smoothMinQuadratic(_ value: Bound) -> Bound {
        let n = max(value - abs(lowerBound - upperBound), 0) / value
        return min(lowerBound, upperBound) - n * n * value * Bound(floatLiteral: 0.25)
    }
}
#endif
