//
//  CylindricalCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

public struct CylindricalCoordinate {
    var radius: Value
    var angle: Value
    var height: Value
}

// MARK: Self: CoordinateSystem
extension CylindricalCoordinate: CoordinateSystem {}

// MARK: CoordinateSystem (EX)
public extension CoordinateSystem where Self == CylindricalCoordinate {
    static func cylindrical(r radius: Value, angle: Value, h height: Value) -> Self {
        .init(radius: radius, angle: angle, height: height)
    }
}
