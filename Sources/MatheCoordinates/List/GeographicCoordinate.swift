//
//  GeographicCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

/// Coordinate that defines a location in the real world
public struct GeographicCoordinate {
    var latitude: Scalar
    var longitude: Scalar
}

// MARK: Self: CoordinateSystem
extension GeographicCoordinate: CoordinateSystem {
    // swiftlint:disable:next missing_docs
    public typealias Scalar = Double
}

// MARK: CoordinateSystem (EX)
public extension CoordinateSystem where Self == GeographicCoordinate {
    /// Creates a new geographic coordinate
    /// - Parameters:
    ///   - lat: Latitude
    ///   - lng: Longitude
    ///
    /// - Returns: A new `GeographicCoordinate` instance
    static func geographic(lat: Scalar, lng: Scalar) -> Self {
        .init(latitude: lat, longitude: lng)
    }
}
