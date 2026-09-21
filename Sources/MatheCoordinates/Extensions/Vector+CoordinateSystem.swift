//
//  Vector+CoordinateSystem.swift
//  Mathe
//
//  Created by Martônio Júnior on 21/09/2026.
//

public import MatheSIMD

@available(macOS 26.0, *)
extension Vector: CoordinateSystem where Scalar: AdditiveArithmetic {
    public var components: [Scalar] { map(\.self) }
}
