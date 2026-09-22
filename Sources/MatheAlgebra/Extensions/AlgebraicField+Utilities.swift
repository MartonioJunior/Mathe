//
//  AlgebraicField+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 02/05/2026.
//

#if Numerics
public import Numerics

public extension AlgebraicField {
    var bestDivideFunction: (Self) -> Self {
        guard let reciprocal else {
            return { $0 / self }
        }

        return { $0 * reciprocal }
    }
}
#endif
