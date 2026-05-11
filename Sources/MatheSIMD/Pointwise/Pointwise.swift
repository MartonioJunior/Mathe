//
//  Pointwise.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/09/2025.
//

/// Represents a type that can be composed a set of component values.
/// 
/// Allows for point-to-point operations.
public protocol Pointwise {
    /// Value that represents one of the component values of a type.
    associatedtype Scalar
    /// Number of scalar components.
    var scalarCount: Int { get }
    /// Accesses one of the scalar components for the type.
    /// - Parameter index: Index of the scalar to be obtained.
    /// - Returns: The scalar value at the given index.
    subscript(_ index: Int) -> Scalar { get set }
    /// Creates a new instance based on it's scalar components.
    /// - Parameter scalars: List of scalar components that compose the type.
    init(scalars: [Scalar])
}

// MARK: Default Implementation
public extension Pointwise {
    /// Range of valid scalar indices.
    var scalarIndices: Range<Int> { 0..<scalarCount }
    /// Checks whether all components fulfill a predicate.
    /// - Parameter predicate: Expression to check.
    /// - Returns: `true` when all components fulfill the predicate, `false` if one of them does not.
    func all(_ predicate: (Scalar) -> Bool) -> Bool {
        scalarIndices.allSatisfy { predicate(self[$0]) }
    }
    /// Checks whether any component fulfills the predicate.
    /// - Parameter predicate: Expression to check.
    /// - Returns: `true` when any component fulfills the predicate, `false` when all of them do not.
    func any(_ predicate: (Scalar) -> Bool) -> Bool {
        scalarIndices.contains { predicate(self[$0]) }
    }
    /// Performs a pointwise merge with a scalar value.
    /// - Parameters:
    ///   - merge: Operation to be performed between scalars.
    ///   - scalar: Value used in the operation.
    ///
    /// - Returns: A new instance of the type with the result of the merge operation with each scalar.
    func callAsFunction(point merge: (Scalar, Scalar) -> Scalar, scalar: Scalar) -> Self {
        pointwise(scalar: scalar, merge: merge)
    }
    /// Performs a pointwise merge with a pointwise value.
    /// - Parameters:
    ///   - merge: Operation to be performed between scalars.
    ///   - rhs: Pointwise used in the operation.
    ///
    /// - Returns: A new instance of the type with the result of the merge operation with each scalar.
    func callAsFunction(point merge: (Scalar, Scalar) -> Scalar, _ rhs: Self) -> Self {
        pointwise(rhs, merge: merge)
    }
    /// Cycles the position of scalars by a given offset.
    /// - Parameter n: Offset to be applied.
    /// - Returns: A new instance of the type with scalars offset by the given amount.
    /// 
    /// Components at the end of the scalar index loop back to the start.
    func cycled(by n: Int = 1) -> Self {
        let offset = n % scalarCount
        return .init(scalars: (1...offset).map {
            self[scalarCount - $0]
        } + scalarIndices.dropLast(offset).map { self[$0] })
    }
    /// Maps each component to a new scalar value.
    /// - Parameter map: Transformation function.
    /// - Returns: A new instance with transformed scalars.
    func pointwise(_ map: (Scalar) -> Scalar) -> Self {
        .init(scalars: scalarIndices.map { map(self[$0]) })
    }
    /// Maps each component to a new scalar value, transformed into a new type.
    /// - Parameters:
    ///   - map: Transformation function.
    ///
    /// - Returns: A new instance of type `P` with the transformed scalars.
    func pointwise<P: Pointwise>(as _: P.Type, _ map: (Scalar) -> P.Scalar) -> P {
        .init(scalars: scalarIndices.map { map(self[$0]) })
    }
    /// Performs an operation between a pointwise and a scalar.
    /// - Parameters:
    ///   - scalar: Value used in the operation.
    ///   - merge: Operation to be performed between scalars.
    ///
    /// - Returns: A new instance with merged scalars.
    func pointwise<S>(scalar: S, merge: (Scalar, S) -> Scalar) -> Self {
        .init(scalars: scalarIndices.map { merge(self[$0], scalar) })
    }
    /// Performs an operation between a pointwise and a scalar, transformed into a new type.
    /// - Parameters:
    ///   - scalar: Value used in the operation.
    ///   - merge: Operation to be performed between scalars.
    ///
    /// - Returns: A new instance of type `P` with the merged scalars.
    func pointwise<S, P: Pointwise>(scalar: S, as _: P.Type, merge: (Scalar, S) -> P.Scalar) -> P {
        .init(scalars: scalarIndices.map { merge(self[$0], scalar) })
    }
    /// Performs an operation between two pointwise instances with the same type of scalar.
    /// - Parameters:
    ///   - rhs: Pointwise part of the operation.
    ///   - merge: Operation to be performed between scalars.
    ///
    /// - Returns: A new instance with merged scalars.
    func pointwise<P: Pointwise>(_ rhs: P, merge: (Scalar, P.Scalar) -> Scalar) -> Self {
        .init(scalars: scalarIndices.map { merge(self[$0], rhs[$0]) })
    }
    /// Performs an operation between a pointwise and a scalar, transformed into a new type.
    /// - Parameters:
    ///   - rhs: Pointwise part of the operation.
    ///   - merge: Operation to be performed between scalars.
    ///
    /// - Returns: A new instance of type `P` with the merged scalars.
    func pointwise<P: Pointwise, S: Pointwise>(_ rhs: P, as _: S.Type, merge: (Scalar, P.Scalar) -> S.Scalar) -> S {
        .init(scalars: scalarIndices.map { merge(self[$0], rhs[$0]) })
    }
    /// Combines all components into a singular value.
    /// - Parameters:
    ///   - initialResult: Initial value for the operation.
    ///   - nextInitialResult: Function that merges scalars.
    ///
    /// - Returns: The resulting scalar after merging all components.
    func reduce(_ initialResult: Scalar, _ nextInitialResult: (Scalar, Scalar) -> Scalar) -> Scalar {
        scalarIndices.map { self[$0] }.reduce(initialResult, nextInitialResult)
    }
}
