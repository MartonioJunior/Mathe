//
//  NSphere+Sphere.swift
//  Mathe
//
//  Created by Martônio Júnior on 26/09/2026.
//

public import MatheCoordinates

@available(macOS 26.0.0, *)
public typealias Sphere<C: CoordinateSystem> = Placed<SphereShape<C.Scalar>, C> where C.Scalar: Numeric
@available(macOS 26.0.0, *)
public typealias SphereShape<Scalar: Numeric> = NSphere<3, Scalar>

// MARK: Numerics (Trait)
#if Numerics
public import Numerics

@available(macOS 26.0.0, *)
public extension NSphere where n == 3, Scalar: Real {
    /// Surface area of the sphere.
    var surfaceArea: Scalar { 4 * .pi * radius * radius }
    /// Volume of the sphere.
    var volume: Scalar { 4 * .pi * .pow(radius, 3) / 3 }
}
#endif
