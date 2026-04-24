//
//  Vector+Numerics.swift
//  Mathe
//
//  Created by Martônio Júnior on 23/04/2026.
//

#if Numerics
public import Numerics

// MARK: Scalar: FloatingPoint
@available(macOS 26.0, *)
public extension Vector where Scalar: FloatingPoint & ElementaryFunctions {
    static func / (lhs: Self, rhs: Scalar) -> Self {
        Self { rhs == 0 ? .nan : lhs[$0] / rhs }
    }

    var normalized: Self {
        let magnitude = self.magnitude
        return if magnitude != 0 {
            self / magnitude
        } else {
            self
        }
    }

    func othorgonalProjection(on vector: Self) -> Scalar {
        let m = magnitude
        let distance = (dot(vector) / (m * vector.magnitude)) * m
        return distance.isNaN ? 0 : distance
    }
}

// MARK: Self.Scalar: Numeric
@available(macOS 26.0, *)
public extension Vector where Scalar: Numeric & Comparable & ElementaryFunctions {
    var magnitude: Scalar { Scalar.root(dot(self), 2) }
}
#endif