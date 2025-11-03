//
//  BarycentricCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

public struct BarycentricCoordinate<Base: CoordinateSystem> {
    var relative: Base
}

// MARK: Self: CoordinateSystem
extension BarycentricCoordinate: CoordinateSystem {}

// MARK: CoordinateSystem (EX)
public extension CoordinateSystem {
    static func relative<Base>(_ relative: Base) -> Self where Self == BarycentricCoordinate<Base> {
        .init(relative: relative)
    }
}
