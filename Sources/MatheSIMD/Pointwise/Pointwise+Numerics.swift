//
//  Pointwise+Numerics.swift
//  Trinkets
//
//  Created by Martônio Júnior on 23/09/2026.
//

#if Numerics
public import Numerics

// MARK: Self.Scalar: AlgebraicField
public extension Pointwise where Scalar: AlgebraicField & Comparable & ElementaryFunctions {
    /// Equivalent pointwise with magnitude `1`.
    var normalized: Self {
        let m = self.magnitude
        return (m != 0) ? self / m : .init(scalars: .init(repeating: .zero, count: scalarCount))
    }
}

// MARK: Self.Scalar: Numeric
public extension Pointwise where Scalar: Numeric & Comparable & ElementaryFunctions {
    /// Absolute length of the pointwise's scalars.
    var magnitude: Scalar { .root(magnitudeSquared, 2) }
}
#endif
