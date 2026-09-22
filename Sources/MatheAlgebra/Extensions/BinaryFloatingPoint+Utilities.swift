//
//  BinaryFloatingPoint+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 22/09/2026.
//

// MARK: Fast Square Root
public extension BinaryFloatingPoint {
    static func bitWave(_ x: Self) -> Self {
        .init(Int(x) & 1)
    }

    static func fastInverseSqrtUnsafe(_ x: Self) -> Self {
        if x == 0 { return 0 }

        var temp = unsafeBitCast(x, to: Int.self)
        temp = 0x5f375a86 - (temp >> 1)
        let f = unsafeBitCast(temp, to: Self.self)
        return (f * (1.5 - (0.5 * x) * f * f)) * x
    }

    static func fsqrtUnsafe(_ x: Self) -> Self {
        if x == 0 { return 0 }

        let s = unsafeBitCast(x, to: Int.self)
        return Self(((s - (1 << 23)) >> 1) + (1 << 29))
    }
}
