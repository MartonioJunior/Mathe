//
//  Int+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 22/09/2026.
//

#if Numerics
import Numerics

public extension Int {
    static func log2(_ x: Self) -> Self {
        let s = UInt(Double(UInt(bitPattern: x)).bitPattern)
        return Self(bitPattern: ((s >> 52) + 1) & .max)
    }
}

#endif
