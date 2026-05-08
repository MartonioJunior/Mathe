//
//  CartesianCoordinate.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/08/2025.
//

public import MatheSIMD

/// Coordinate that defines position in relation to a set of axises.
/// 
/// Assumes that the base is axis-aligned with the cartesian plane.
@available(macOS 26.0, *)
@dynamicMemberLookup
public struct CartesianCoordinate<let N: Int, Scalar: AdditiveArithmetic> {
    // MARK: Variables
    var base: Vector<N, Scalar>
    /// Proxy for accessing values in the base vector.
    /// - Parameter keyPath: Key path to the vector property.
    /// - Returns: The accessed property on the vector.
    public subscript<T>(dynamicMember keyPath: KeyPath<Vector<N, Scalar>, T>) -> T {
        base[keyPath: keyPath]
    }
    /// Proxy for accessing and setting values in the base vector.
    /// - Parameter keyPath: Writable Key path to the vector property.
    /// - Returns: The accessed property on the vector.
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Vector<N, Scalar>, T>) -> T {
        get { base[keyPath: keyPath] }
        set { base[keyPath: keyPath] = newValue }
    }

    // MARK: Initializers
    init(base: Vector<N, Scalar>) {
        self.base = base
    }

    init(_ values: [N of Scalar]) {
        self.init(base: .init(values))
    }
}

// MARK: Self: CoordinateSystem
@available(macOS 26.0, *)
extension CartesianCoordinate: CoordinateSystem {
    public var components: Vector<N, Scalar> { base }
}

// MARK: Self: Equatable
@available(macOS 26.0, *)
extension CartesianCoordinate: Equatable where Scalar: Equatable {}

// MARK: Self: Pointwise
@available(macOS 26.0, *)
extension CartesianCoordinate: Pointwise {
    // swiftlint:disable:next missing_docs
    public var scalarCount: Int { base.scalarCount }
    // swiftlint:disable:next missing_docs
    public subscript(index: Int) -> Scalar {
        get { base[index] }
        set { base[index] = newValue }
    }
    // swiftlint:disable:next missing_docs
    public init(scalars: [Scalar]) {
        self.init(base: .init(scalars: scalars))
    }
}

// MARK: CoordinateSystem (EX)
@available(macOS 26.0, *)
public extension CoordinateSystem {
    /// Creates a new two-dimensional cartesian coordinate.
    /// - Parameters:
    ///   - x: Value in the X axis.
    ///   - y: Value in the Y axis.
    ///
    /// - Returns: A new two-dimensional `CartesianCoordinate` instance.
    static func cartesian<T>(x: T, y: T) -> Self where Self == CartesianCoordinate<2, T> {
        .init([x, y])
    }
    /// Creates a new three-dimensional cartesian coordinate.
    /// - Parameters:
    ///   - x: Value in the X axis.
    ///   - y: Value in the Y axis.
    ///   - z: Value in the Z axis.
    ///
    /// - Returns: A new three-dimensional `CartesianCoordinate` instance.
    static func cartesian<T>(x: T, y: T, z: T) -> Self where Self == CartesianCoordinate<3, T> {
        .init([x, y, z])
    }
    /// Creates a new N-dimensional cartesian coordinate.
    /// - Parameters:
    ///   - x: Vector that defines the cartesian coordinate.
    ///
    /// - Returns: A new N-dimensional `CartesianCoordinate` instance.
    static func cartesian<let N: Int, T>(_ vector: Vector<N, T>) -> Self  where Self == CartesianCoordinate<N, T> {
        .init(base: vector)
    }
}
