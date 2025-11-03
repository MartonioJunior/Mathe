//
//  GeographicCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

public struct GeographicCoordinate {
    var latitude: Value
    var longitude: Value
}

// MARK: Self: CoordinateSystem
extension GeographicCoordinate: CoordinateSystem {}

// MARK: CoordinateSystem (EX)
public extension CoordinateSystem where Self == GeographicCoordinate {
    static func geographic(lat: Value, lng: Value) -> Self {
        .init(latitude: lat, longitude: lng)
    }
}
