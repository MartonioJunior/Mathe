//
//  Ellipsoid.swift
//  Mathe
//
//  Created by Martônio Júnior on 25/09/2026.
//

import MatheSIMD

@available(macOS 26.0.0, *)
public struct Ellipsoid<let n: Int, Scalar: Numeric> {
    /// Radiuses of the ellipsoid.
    var radius: Vector<n, Scalar>
}
