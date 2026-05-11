//
//  Vector.swift
//  CoreCollections
//
//  Created by Martônio Júnior on 12/07/2025.
//

/// Fixed-size linear collection of scalar values.
@available(macOS 26.0, *)
public struct Vector<let N: Int, Scalar> {
    // MARK: Variables
    /// List of components for the vector.
    var elements: [N of Scalar]
    // MARK: Subscripts
    /// Vector component from the specified index.
    /// - Parameter index: Index for the component.
    /// - Returns: The scalar at the given index.
    public subscript(_ index: Int) -> Scalar {
        get { elements[index] }
        set { elements[index] = newValue }
    }
    // MARK: Initializers
    /// Creates a new vector from an `InlineArray`.
    /// - Parameter elements: Inline array of components.
    public init(_ elements: [N of Scalar]) {
        self.elements = elements
    }
    /// Creates a new vector from a index-to-scalar map.
    /// - Parameter body: Index-to-scalar transformation function.
    /// - Throws: Error `E` when the transformation encounters a problem.
    public init<E: Error>(_ body: (Int) throws(E) -> Scalar) rethrows {
        self.elements = try InlineArray(body)
    }
    /// Creates a new vector from an existing array of values.
    /// - Parameters:
    ///   - sequence: Array of values.
    ///   - default: Fallback value for when an scalar index is not part of the given sequence.
    ///
    public init(sequence: [Scalar], default: Scalar) {
        self.init {
            if sequence.indices.contains($0) {
                sequence[$0]
            } else {
                `default`
            }
        }
    }
    // MARK: Methods
    /// Creates a new vector by transforming it's components.
    /// - Parameter transform: Transformation function.
    /// - Returns: A new vector of the same size with the transformed scalar components.
    /// - Throws: Error `E` when the transformation encounters a problem.
    public func map<T, E: Error>(_ transform: (Scalar) throws(E) -> T) rethrows -> Vector<N, T> {
        try .init { try transform(elements[$0]) }
    }
    /// Applies a boolean mask to the vector components.
    /// 
    /// `true` maintains the component as is, while `false` replaces it with a fallback value.
    /// - Parameters:
    ///   - mask: Boolean mask vector.
    ///   - fallback: Value used as a replacement.
    ///
    /// - Returns: A new vector with the masked and replaced components.
    public func masked(by mask: Vector<N, Bool>, fallback: Scalar) -> Self {
        .init { mask[$0] ? self[$0] : fallback }
    }
}

// MARK: DotSyntax
@available(macOS 26.0, *)
public extension Vector {
    /// Creates a new basis vector.
    /// - Parameters:
    ///   - index: Relevant index of the basis.
    ///   - value: Scalar to be used for the relevant index.
    ///   - fallback: Scalar to be used for all other indices.
    ///
    /// - Returns: A new basis vector with `value` in it's most relevant index and `fallback` everywhere else.
    static func basis(_ index: Int, value: Scalar, fallback: Scalar) -> Self {
        .init { $0 == index ? value : fallback }
    }
    /// Creates a vector that repeats a value for all it's components.
    /// - Parameter value: Value to be repeated.
    /// - Returns: A new vector with all components as `value`.
    static func repeating(_ value: @autoclosure () -> Scalar) -> Self {
        .init { _ in value() }
    }
    /// Creates a "matrix" composition with an inline array nested in another.
    /// 
    /// This is meant as an input for a matrix initializer.
    /// - Parameter matrix: Nested inline array.
    /// - Returns: Vector where the component is another vector.
    static func matrix<let A: Int, T>(_ matrix: [N of [A of T]]) -> Self where Scalar == Vector<A, T> {
        .init { .init(matrix[$0]) }
    }
    /// Creates a "matrix" composition with an inline array of vectors.
    /// - Parameter matrix: Inline array of vectors.
    /// - Returns: Vector where the component is another vector.
    static func matrix<let A: Int, T>(_ matrix: [N of Vector<A, T>]) -> Self where Scalar == Vector<A, T> {
        .init { matrix[$0] }
    }
    /// Creates a "matrix" composition with a index-to-scalar map.
    /// - Parameter map: Transformation function (first value is index, second value is subindex).
    /// - Returns: Vector where the component is another vector.
    static func matrix<let A: Int, T>(_ map: (Int, Int) -> T) -> Self where Scalar == Vector<A, T> {
        .init { index in .init { subindex in map(index, subindex) } }
    }
}

// MARK: Self: Equatable
@available(macOS 26.0, *)
extension Vector: Equatable where Scalar: Equatable {}

// MARK: Self: Sendable
@available(macOS 26.0, *)
extension Vector: Sendable where Scalar: Sendable {}
