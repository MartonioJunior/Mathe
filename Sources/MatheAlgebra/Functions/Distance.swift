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
    // MARK: Methods
    /// Calculates the distance between values.
    /// - Parameters:
    ///   - start: Start point.
    ///   - end: End point.
    ///
    /// Returns: Value representing the distance between two values.
    public func callAsFunction(from start: Value, to end: Value) -> T {
        f(start, end)
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

// TODO: Spherical Distance (Great-Circle Distance)

// MARK: Numerics (Trait)
#if Numerics
public import Numerics
public import MatheSIMD

public extension Distance where Value: Pointwise, Value.Scalar: SignedNumeric & Comparable & ElementaryFunctions, Value.Scalar == T {
    static var chebyshev: Self {
        .init { ($0 .- $1).max.value }
    }
    /// Minkowsi distance between two values.
    /// - Parameter exponent: Exponent used in the formula.
    /// - Returns:
    static func minkowski(_ exponent: Int) -> Self {
        .init { $0.pointwise($1) { .pow(abs($0 - $1), exponent) }.componentSum.pow(1 / exponent)  }
    }
}
#endif
