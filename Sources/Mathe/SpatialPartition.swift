//
//  SpatialPartition.swift
//  Mathe
//
//  Created by Martônio Júnior on 23/12/2025.
//

public import MatheCoordinates
public import MatheRange
import MatheSIMD

public protocol SpatialPartition<Space, Value> {
    associatedtype Space: Boundary where Space.Bound: CoordinateSystem
    associatedtype Value

    var space: Space { get }
    var value: Value { get }
}
