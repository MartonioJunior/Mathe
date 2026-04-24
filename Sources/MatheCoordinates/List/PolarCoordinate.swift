//
//  PolarCoordinate.swift
//  Trinkets
//
//  Created by Martônio Júnior on 12/07/2025.
//

public struct PolarCoordinate {
    // MARK: Variables
    public var radius: Value
    public var angle: Value
}

// MARK: Self: CoordinateSystem
extension PolarCoordinate: CoordinateSystem {}

// MARK: CoordinateSystem (EX)
public extension CoordinateSystem where Self == PolarCoordinate {
    static func polar(r: Value, a: Value) -> Self {
        .init(radius: r, angle: a)
    }
}
