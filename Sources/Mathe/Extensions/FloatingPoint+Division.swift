//
//  FloatingPoint+Division.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/01/2026.
//

public extension FloatingPoint {
    static func lcm(_ lhs: Self, _ rhs: Self) -> Self {
        if lhs == 0 || rhs == 0 { return .zero }

        return lhs / gcd(lhs, rhs) * rhs
    }
}
