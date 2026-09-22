//
//  FixedWidthInteger+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 22/09/2026.
//

public extension FixedWidthInteger {
    var isPowerOfTwo: Bool { self > 0 && nonzeroBitCount == 1 }
}
