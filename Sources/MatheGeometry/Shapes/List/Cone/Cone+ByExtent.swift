//
//  Cone+ByExtent.swift
//  Mathe
//
//  Created by Martônio Júnior on 26/09/2026.
//

public import MatheSIMD

public extension ConeShaped {
    // Assumes the origin to be the center of the shape.
    @available(macOS 26.0, *)
    struct ByExtent<Scalar: Numeric> {
        var extents: Vector<2, Scalar>

        var height: Scalar { extents[1] * 2 }
        var radius: Scalar { extents[0] }
    }
}

// MARK: Placed (EX)
@available(macOS 26.0, *)
public extension Placed where Coordinate: Pointwise, Element == ConeShaped.ByExtent<Coordinate.Scalar> {
    var bottom: Coordinate { position - element.extents[1] }
    var tip: Coordinate { position + element.extents[1] }
}

// MARK: Numerics (Trait)
#if Numerics
public import Numerics

@available(macOS 26.0, *)
public extension ConeShaped.ByExtent where Scalar: Real {
    var slant: Scalar { .sqrt(radius * radius + height * height) }
}
#endif
