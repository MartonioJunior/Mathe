//
//  CartesianCoordinate.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/08/2025.
//

public import MatheSIMD

/// Coordinate that defines position in relation to a set of axises
/// 
/// Assumes that the base is axis-aligned
@available(macOS 26.0, *)
@dynamicMemberLookup
public struct CartesianCoordinate<let N: Int, Scalar: AdditiveArithmetic> {
    // MARK: Variables
    var base: Vector<N, Scalar>

    public subscript<T>(dynamicMember keyPath: KeyPath<Vector<N, Scalar>, T>) -> T {
        base[keyPath: keyPath]
    }

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
    public var scalarCount: Int { base.scalarCount }

    public subscript(index: Int) -> Scalar {
        get { base[index] }
        set { base[index] = newValue }
    }

    public init(scalars: [Scalar]) {
        self.init(base: .init(scalars: scalars))
    }
}

// MARK: CoordinateSystem (EX)
@available(macOS 26.0, *)
public extension CoordinateSystem {
    static func cartesian<T>(x: T, y: T) -> Self where Self == CartesianCoordinate<2, T> {
        .init([x, y])
    }

    static func cartesian<T>(x: T, y: T, z: T) -> Self where Self == CartesianCoordinate<3, T> {
        .init([x, y, z])
    }

    static func cartesian<let N: Int, T>(_ vector: Vector<N, T>) -> Self  where Self == CartesianCoordinate<N, T> {
        .init(base: vector)
    }
}
