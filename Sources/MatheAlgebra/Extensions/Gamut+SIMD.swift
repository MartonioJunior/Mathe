//
//  Gamut+SIMD.swift
//  Mathe
//
//  Created by Martônio Júnior on 22/09/2026.
//

#if Numerics
public import MatheRange
public import MatheSIMD
import Numerics

@available(macOS 26.0, *)
public extension Gamut where Bound == Vector<3, Double> {
    func parabola(_ height: Bound.Scalar, t: Bound.Scalar) -> Bound {
        let d = lowerBound.pointwise(upperBound) { Extent(from: $0, to: $1).distance }

        if abs(d.y) < 0.1 {
            var result = lowerBound + t * d
            result.y += .sin(t) * height
            return result
        }

        var up = d.cross(upperBound - Vector<3, Double>([lowerBound.x, upperBound.y, lowerBound.z])).cross(d)

        if upperBound.y > lowerBound.y {
            up = -up
        }

        return (lowerBound + t * d) + .sin(t) * height * up.normalized
    }
}
#endif