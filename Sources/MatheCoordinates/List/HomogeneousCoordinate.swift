//
//  HomogeneousCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

public struct HomogeneousCoordinate<Base: CoordinateSystem> {
    var base: Base
    var w: Value
}

// MARK: Self: CoordinateSystem
extension HomogeneousCoordinate: CoordinateSystem {}

// MARK: CoordinateSystem (EX)
public extension CoordinateSystem {
    static func homogeneous<Base>(_ base: Base, w: Double) -> Self where Self == HomogeneousCoordinate<Base> {
        .init(base: base, w: w)
    }
}
