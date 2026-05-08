//
//  CylindricalCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

/// Coordinate that represents a position based on a cylinder shape
public struct CylindricalCoordinate<Scalar: AdditiveArithmetic> {
    var radius: Scalar
    var angle: Scalar
    var height: Scalar
}

// MARK: Self: CoordinateSystem
extension CylindricalCoordinate: CoordinateSystem {}

// MARK: CoordinateSystem (EX)
public extension CoordinateSystem {
    /// Creates a new cylindrical coordinate
    /// - Parameters:
    ///   - radius: The radius of the base
    ///   - angle: Angle for the coordinate
    ///   - height: Y position for the coordinate
    ///
    /// - Returns: A new `CylindricalCoordinate` instance
    static func cylindrical<T>(r radius: T, angle: T, h height: T) -> Self where Self == CylindricalCoordinate<T> {
        .init(radius: radius, angle: angle, height: height)
    }
}
