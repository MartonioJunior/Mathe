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
public struct BarycentricCoordinate<let n: Int, Scalar: Numeric & Comparable> {
    // MARK: Variables
    /// Components that describe the barycentric coordinate
    var base: Vector<n, Scalar>
    /// Defines the distance between the point and the center
    public var distanceFromCenter: Vector<n, Scalar> {
        .init { 1 - base[$0] }
    }
    /// Is the coordinate on the center of the reference shape?
    public var isCenter: Bool { base.all { $0 == 1 } }
    /// Is the coordinate inside of the shape?
    public var isInside: Bool { base.all { $0 > .zero } }
    /// Is the coordinate outside of the shape?
    public var isOutside: Bool { base.any { $0 < .zero } }
    /// Is the coordinate on the shape's border?
    public var isTangent: Bool { base.any { $0 == .zero } }
    // MARK: Initializers
    init(ceil base: Vector<n, Scalar>) {
        self.base = base.map { (...1).ceil($0) }
    }
}

// MARK: Self: CoordinateSystem
@available(macOS 26.0.0, *)
extension BarycentricCoordinate: CoordinateSystem {
    // swiftlint:disable:next missing_docs
    public typealias Components = Vector<n, Scalar>
    // swiftlint:disable:next missing_docs
    public var components: Components { base }
    // swiftlint:disable:next missing_docs
    public func offset(by displacement: Components) -> Self {
        .init(ceil: base .+ displacement)
    }
}

// MARK: CoordinateSystem (EX)
@available(macOS 26.0.0, *)
public extension CoordinateSystem {
    /// Creates a new barycentric coordinate from a vector.
    /// 
    /// All values are clamped using a ceiling function, putting
    /// the numbers in the `...1` range
    /// - Parameter base: Vector with all components for the coordinate
    /// - Returns: A new valid `BarycentricCoordinate` instance
    static func barycentric<let n: Int, Scalar>(
        ceil base: Vector<n, Scalar>
    ) -> Self where Self == BarycentricCoordinate<n, Scalar> {
        .init(ceil: base)
    }
}
