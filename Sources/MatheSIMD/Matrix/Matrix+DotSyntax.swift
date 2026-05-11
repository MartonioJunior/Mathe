//
//  Matrix+DotSyntax.swift
//  Mathe
//
//  Created by Martônio Júnior on 11/05/2026.
//

@available(macOS 26.0.0, *)
public extension Matrix {
    /// Creates a new three-dimensional matrix from nested inline arrays.
    /// - Parameter matrix: Nested inline arrays.
    /// - Returns: A three-dimensional matrix of elements.
    static func composite<let A: Int, T>(
        _ matrix: [Rows of [Columns of [A of T]]]
    ) -> Self where Scalar == Vector<A, T> {
        .init { .init(matrix[$0.row][$0.column]) }
    }
    /// Creates a new three-dimensional matrix from nested inline arrays of vectors.
    /// - Parameter matrix: Nested inline arrays of vectors.
    /// - Returns: A three-dimensional matrix of elements.
    static func composite<let A: Int, T>(
        _ matrix: [Rows of [Columns of Vector<A, T>]]
    ) -> Self where Scalar == Vector<A, T> {
        .init { matrix[$0.row][$0.column] }
    }
    /// Creates a new four-dimensional matrix from nested inline arrays of matrices.
    /// - Parameter matrix: Nested inline arrays of matrices.
    /// - Returns: A four-dimensional matrix of elements.
    static func composite<let A: Int, let B: Int, T>(
        _ matrix: [Rows of [Columns of Matrix<A, B, T>]]
    ) -> Self where Scalar == Matrix<A, B, T> {
        .init { matrix[$0.row][$0.column] }
    }
    /// Creates a new three-dimensional matrix from a map function.
    /// - Parameter map: Function transformation.
    /// - Returns: A three-dimensional matrix of elements.
    static func composite<let A: Int, T>(
        _ map: (Position, Int) -> T
    ) -> Self where Scalar == Vector<A, T> {
        .init { index in .init { subindex in map(index, subindex) } }
    }
    /// Creates a new four-dimensional matrix from a map function.
    /// - Parameter map: Function transformation.
    /// - Returns: A four-dimensional matrix of elements.
    static func composite<let A: Int, let B: Int, T>(
        _ map: (Position, Position) -> T
    ) -> Self where Scalar == Matrix<A, B, T> {
        .init { index in .init { subindex in map(index, subindex) } }
    }
    /// Creates a matrix that repeats a value for all it's positions.
    /// - Parameter value: Value to be repeated.
    /// - Returns: A new matrix where all of it's elements are `value`.
    static func repeating(_ value: @autoclosure () -> Scalar) -> Self {
        .init { _ in value() }
    }
}
