//
//  Capsule+ByExtent.swift
//  Mathe
//
//  Created by Martônio Júnior on 26/09/2026.
//

import MatheSIMD

public extension CapsuleShaped {
    /// Representation that models the capsule through radius and height extents.
    @available(macOS 26.0.0, *)
    struct ByExtent<Scalar: Numeric> {
        var extents: Vector<2, Scalar>

        var radius: Scalar { extents[0] }
        var height: Scalar { extents[1] * 2 }
    }
}
