//
//  MalleableCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 25/11/2025.
//

/// Coordinate system where it's position can be represented by any number of values
/// 
/// This allows the coordinate to change dimensions with no issues
public struct MalleableCoordinate<Scalar: AdditiveArithmetic> {
    // MARK: Variables
    public var components: [Scalar]

    // MARK: Initializers
    public init(_ components: [Scalar]) {
        self.components = components
    }

    // MARK: Subscripts
    public subscript(axis: Int) -> Scalar {
        get { components[axis] }
        set { components[axis] = newValue }
    }
}

// MARK: Self: CoordinateSystem
extension MalleableCoordinate: CoordinateSystem {}

// MARK: Self: Equatable
extension MalleableCoordinate: Equatable {}

// MARK: Self: ExpressibleByArrayLiteral
extension MalleableCoordinate: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Scalar...) {
        self.init(elements)
    }
}
