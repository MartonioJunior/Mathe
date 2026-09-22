//
//  BinaryInteger+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 22/09/2026.
//

public extension BinaryInteger {
    var isEven: Bool { (self & 1) == 0 }
    var isOdd: Bool { (self & 1) == 1 }
    var isPowerOfTwo: Bool { self != .zero && (self & (self - 1)) == .zero }

    static func bitWave(_ x: Self) -> Self {
        .init(Int(x) & 1)
    }
}

// MARK: Numerics (Trait)
#if Numerics
import Numerics

public extension BinaryInteger {
    func snap(step: Self) -> Self {
        Self(Double(self).snap(step: Double(step)))
    }
}
#endif
