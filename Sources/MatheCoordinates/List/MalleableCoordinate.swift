//
//  MalleableCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 25/11/2025.
//

public struct MalleableCoordinate<Value> {
    // MARK: Variables
    var values: [Value]

    // MARK: Subscripts
    public subscript(axis: Int) -> Value {
        get { values[axis] }
        set { values[axis] = newValue }
    }
}

// MARK: Self: CoordinateSystem
extension MalleableCoordinate: CoordinateSystem {}

// MARK: Self: ExpressibleByArrayLiteral
extension MalleableCoordinate: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Value...) {
        self.init(values: elements)
    }
}
