//
//  Distance.swift
//  Core
//
//  Created by Martônio Júnior on 28/09/2025.
//

/// Function that returns a value based on the distance between two values.
public struct Distance<Value, T> {
    // MARK: Variables
    var f: (Value, Value) -> T
    /// Creates a new distance function.
    /// - Parameter f: Function used to calculate distance.
    public init(_ f: @escaping (Value, Value) -> T) {
        self.f = f
    }
}

// MARK: DotSyntax
public extension Distance where Value: Numeric, Value.Magnitude == T {
    /// Euclidean distance between two values.
    static var euclidean: Self { .init { ($0 - $1).magnitude } }
}

public extension Distance where Value: SignedNumeric & Comparable, Value == T {
    /// Manhattan distance between two values.
    static var manhattan: Self { .init { abs($0 - $1) } }
}
