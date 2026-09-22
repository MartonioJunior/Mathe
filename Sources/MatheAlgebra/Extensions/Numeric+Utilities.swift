//
//  Numeric+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 02/05/2026.
//

public extension Numeric {
    static func bit(_ value: Bool) -> Self { value ? 1 : 0 }

    static func loopPow(_ x: Self, e n: Int) -> Self {
        (0..<n).reduce(1) { acc, _ in acc * x }
    }
}
