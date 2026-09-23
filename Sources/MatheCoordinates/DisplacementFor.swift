//
//  Displacer.swift
//  Mathe
//
//  Created by Martônio Júnior on 23/09/2026.
//

public import MatheSIMD

/// Wrapper for coordinates to allow them to be used as displacement vectors.
public struct DisplacementFor<C: CoordinateSystem> {
    var offset: C
}

// MARK: Self: Pointwise
extension DisplacementFor: Pointwise where C: Pointwise {
    // swiftlint:disable:next missing_docs
    public var scalarCount: Int { offset.scalarCount }
    // swiftlint:disable:next missing_docs
    public subscript(index: Int) -> C.Scalar {
        get { offset[index] }
        set { offset[index] = newValue }
    }
    // swiftlint:disable:next missing_docs
    public init(scalars: [C.Scalar]) {
        self.offset = .init(scalars: scalars)
    }
}
