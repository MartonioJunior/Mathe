//
//  SpatialPartition.swift
//  Mathe
//
//  Created by Martônio Júnior on 23/12/2025.
//

public import MatheRange
import MatheSIMD

/// A collection of elements organized by their position for spatial search purposes
public protocol SpatialPartition<Field, Element> {
    /// Boundary that represents the space in the data structure.
    associatedtype Field: Boundary where Field.Bound: CoordinateSystem
    /// A type representing the collection's elements.
    associatedtype Element
    // MARK: Variables
    /// Boundary where all of the collection's elements are contained within.
    var boundary: Field { get }
}
