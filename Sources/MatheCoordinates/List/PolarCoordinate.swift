//
//  PolarCoordinate.swift
//  Trinkets
//
//  Created by Martônio Júnior on 12/07/2025.
//

import Numerics

public struct PolarCoordinate {
    // MARK: Variables
    var radius: Value
    var angle: Value

    // MARK: Methods
    public func toCartesian() -> CartesianCoordinate {
        .init(x: radius * Value.cos(angle), y: radius * Value.sin(angle))
    }
}

// MARK: Self: CoordinateSystem
extension PolarCoordinate: CoordinateSystem {}

// MARK: CoordinateSystem (EX)
public extension CoordinateSystem where Self == PolarCoordinate {
    static func polar(r: Value, a: Value) -> Self {
        .init(radius: r, angle: a)
    }
}
