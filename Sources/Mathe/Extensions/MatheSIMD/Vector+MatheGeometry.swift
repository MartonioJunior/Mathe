//
//  Vector+MatheGeometry.swift
//  Mathe
//
//  Created by Martônio Júnior on 22/09/2026.
//

// MARK: Numerics (Trait)
#if Numerics
public import Numerics

@available(macOS 26.0, *)
public extension Vector where Self: Gamut, Scalar.Bound: AlgebraicField {
    var asAABB: AxisAlignedBoundingBox<N, Scalar.Bound> {
        .init(min: .cartesian(lowerBound), max: .cartesian(upperBound))
    }
}
#endif
