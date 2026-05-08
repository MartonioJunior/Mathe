//
//  BarycentricCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

import MatheRange
public import MatheSIMD

/// Coordinate system where it's values represent the proportional distance to the center of a shape
@available(macOS 26.0.0, *)
public struct BarycentricCoordinate<let N: Int, Scalar: Numeric & Comparable> {
    // MARK: Variables
    /// Components that describe the barycentric coordinate
    var base: Vector<N, Scalar>
    /// Defines the distance between the point and the center
    public var distanceFromCenter: Vector<N, Scalar> {
        .init { 1 - base[$0] }
    }
    // MARK: Initializers
    init(ceil base: Vector<N, Scalar>) {
        self.base = base.map { (...1).ceil($0) }
    }
}

// MARK: Self: CoordinateSystem
@available(macOS 26.0.0, *)
extension BarycentricCoordinate: CoordinateSystem {}

// MARK: CoordinateSystem (EX)
@available(macOS 26.0.0, *)
public extension CoordinateSystem {
    /// Creates a new barycentric coordinate from a vector.
    /// 
    /// All values are clamped using a ceiling function, putting
    /// the numbers in the `...1` range
    /// - Parameter base: Vector with all components for the coordinate
    /// - Returns: A new valid `BarycentricCoordinate` instance
    static func barycentric<let N: Int, Scalar>(
        ceil base: Vector<N, Scalar>
    ) -> Self where Self == BarycentricCoordinate<N, Scalar> {
        .init(ceil: base)
    }
}
