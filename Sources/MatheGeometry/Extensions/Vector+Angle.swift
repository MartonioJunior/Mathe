//
//  Vector+Angle.swift
//  Mathe
//
//  Created by Martônio Júnior on 02/05/2026.
//

#if Numerics
import MatheRange
public import MatheSIMD
public import Numerics

@available(macOS 26.0, *)
public extension Vector where Scalar: Real & Comparable {
    @_disfavoredOverload
    func cross(_ rhs: Self) -> Scalar {
        magnitude * rhs.magnitude * .sin(Self.angle(from: self, to: rhs))
    }

    /// Returns an angle in radians between two vectors
    static func angle(from a: Self, to b: Self) -> Scalar {
        let num = (Scalar.pow(a.magnitude, 2) * .pow(b.magnitude, 2)).squareRoot()
        return .acos(a.dot(b) / num).clampMagnitude(1)
    }

    static func preciseAngle(from a: Self, to b: Self) -> Scalar {
        let c = a.normalized
        let d = b.normalized

        return if a.dot(b) < 0 {
            .pi - 2 * .asin((-c .- d).magnitude / 2)
        } else {
            2 * .asin((c .- d).magnitude / 2)
        }
    }
}

@available(macOS 26.0, *)
public extension Vector where Scalar: Real & Comparable, N == 2 {
    static func signedAngle(from a: Self, to b: Self) -> Scalar {
        angle(from: a, to: b) * Scalar(a.cross(b).sign.rawValue)
    }
}

@available(macOS 26.0, *)
public extension Vector where Scalar: Real, N == 3 {
    static func straightSignedAngle(from a: Self, to b: Self, n: Self) -> Scalar {
        .atan2(y: n.dot(a.cross(b)), x: a.dot(b))
    }
}
#endif
