//
//  CartesianCoordinate.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/08/2025.
//

public struct CartesianCoordinate {
    // MARK: Variables
    var x: Value
    var y: Value
}

// MARK: Self: CoordinateSystem
extension CartesianCoordinate: CoordinateSystem {}

// MARK: CoordinateSystem (EX)
public extension CoordinateSystem where Self == CartesianCoordinate {
    static func cartesian(x: Value, y: Value) -> Self {
        .init(x: x, y: y)
    }
}
