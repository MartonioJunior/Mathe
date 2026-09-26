//
//  Cone+RadiusHeight.swift
//  Mathe
//
//  Created by Martônio Júnior on 26/09/2026.
//

public import MatheSIMD

public extension ConeShaped {
    // Assumes the origin to be the bottom of the shape.
    struct RadiusHeight<Scalar: Numeric> {
        var radius: Scalar
        var height: Scalar
    }
}

// MARK: Placed (EX)
public extension Placed where Coordinate: Pointwise, Element == ConeShaped.RadiusHeight<Coordinate.Scalar> {
    var bottom: Coordinate { position }
    var tip: Coordinate { position + element.height }
}

// MARK: Numerics (Trait)
#if Numerics
public import Numerics

public extension ConeShaped.RadiusHeight where Scalar: Real {
    var slant: Scalar { .sqrt(radius * radius + height * height) }
}
#endif
