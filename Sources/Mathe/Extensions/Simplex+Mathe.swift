//
//  Simplex+Mathe.swift
//  Mathe
//
//  Created by Martônio Júnior on 06/05/2026.
//

#if Numerics
import Numerics

// MARK: n == 1 (Line)
@available(macOS 26.0.0, *)
public extension Simplex where n == 1, Vertex: CoordinateSystem & Pointwise, Vertex.Scalar: BinaryFloatingPoint {
    /// Provides an approximation of the magnitude using a fast inverse square root.
    var approximateMagnitude: Vertex.Scalar {
        .fastInverseSqrtUnsafe(Self(from: end, to: start).delta.magnitudeSquared)
    }
    /// Provides a faster calculation of approximate accuracy.
    var fastMagnitude: Vertex.Scalar {
        .fsqrtUnsafe(Self(from: end, to: start).delta.magnitudeSquared)
    }
}
#endif
