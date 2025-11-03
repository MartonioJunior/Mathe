//
//  SphericalCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

public struct SphericalCoordinate {
    var radius: Value
    var angleX: Value
    var angleY: Value
}

// MARK: Self: CoordinateSystem
extension SphericalCoordinate: CoordinateSystem {}

// MARK: CoordinateSystem (EX)
public extension CoordinateSystem where Self == SphericalCoordinate {
    static func spherical(r radius: Value, theta: Value, phi: Value) -> Self {
        .init(radius: radius, angleX: theta, angleY: phi)
    }
}
