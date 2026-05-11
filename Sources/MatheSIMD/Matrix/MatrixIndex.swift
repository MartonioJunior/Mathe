//
//  MatrixIndex.swift
//  Trinkets
//
//  Created by Martônio Júnior on 25/04/2025.
//

/// Data structure that defines position for a matrix of N-dimensions.
@available(macOS 26, *)
public struct MatrixIndex<let N: Int> {
    /// Returns a position where it's all components are zero
    public static var zero: Self { .init(.zero) }
    /// Components that describe a position in the matrix.
    public var elements: Vector<N, Int>
    /// Component in a given axis of the index.
    /// - Parameter index: Axis to access.
    /// - Returns: The current index for a given axis.
    public subscript(_ index: Int) -> Int {
        get { elements[index] }
        set { elements[index] = newValue }
    }
    /// Creates a new position.
    /// - Parameter elements: List of components that compose this position
    public init(_ elements: Vector<N, Int>) {
        self.elements = elements
    }
}

// MARK: N == 2
@available(macOS 26, *)
public extension MatrixIndex where N == 2 {
    /// Column of the matrix.
    var column: Int { elements[1] }
    /// Row of the matrix.
    var row: Int { elements[0] }
    /// Creates a new position from row and column indices.
    /// - Parameters:
    ///   - r: Row index.
    ///   - c: Column index.
    ///
    init(r: Int, c: Int) {
        self.elements = [r, c]
    }
}

// MARK: Self: Comparable
@available(macOS 26, *)
extension MatrixIndex: Comparable {
    // swiftlint:disable:next missing_docs
    public static func < (lhs: Self, rhs: Self) -> Bool {
        for i in 0..<N {
            if lhs[i] == rhs[i] { continue }

            return lhs[i] < rhs[i]
        }

        return false
    }
}

// MARK: Self: Equatable
@available(macOS 26, *)
extension MatrixIndex: Equatable {}
