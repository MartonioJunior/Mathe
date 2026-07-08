//
//  Distance.swift
//  Core
//
//  Created by Martônio Júnior on 28/09/2025.
//

/// Function that returns a value based on the distance between two values.
/// 
/// For a distance function, the following principles must apply:
/// - The distance between a value and itself is always zero.
/// - The distance between distinct values is always positive.
/// - The distance between distinct values does not change when the order of parameters change.
/// - The distance between distinct values is not greater than the sum of the distance of the same values through an intermediary.
public struct Distance<Value, T> {
    // MARK: Variables
    var f: (Value, Value) -> T
    // MARK: Initializers
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
