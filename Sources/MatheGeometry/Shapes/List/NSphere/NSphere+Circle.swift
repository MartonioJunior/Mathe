//
//  NSphere+Circle.swift
//  Mathe
//
//  Created by Martônio Júnior on 26/09/2026.
//

public import MatheCoordinates

@available(macOS 26.0.0, *)
public typealias Circle<C: CoordinateSystem> = Placed<CircleShape<C.Scalar>, C> where C.Scalar: Numeric
@available(macOS 26.0.0, *)
public typealias CircleShape<Scalar: Numeric> = NSphere<2, Scalar>

// MARK: Numerics (Trait)
#if Numerics
public import Numerics

@available(macOS 26.0.0, *)
public extension NSphere where n == 2, Scalar: Real {
    /// Surface area of the circle.
    var surfaceArea: Scalar { .pi * radius * radius }
}
#endif
