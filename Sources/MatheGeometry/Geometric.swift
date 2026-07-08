//
//  Geometric.swift
//  Mathe
//
//  Created by Martônio Júnior on 25/11/2025.
//

public import MatheCoordinates

/// Representation of a space
public protocol Geometric {
    /// Coordinate system used to uniquely represent a point in space
    associatedtype Coordinate: CoordinateSystem
}
