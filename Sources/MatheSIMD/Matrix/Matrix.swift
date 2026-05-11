//
//  Matrix.swift
//  Trinkets
//
//  Created by Martônio Júnior on 25/04/25.
//

/// Alternative alias for `Matrix`
@available(macOS 26.0, *)
public typealias Matrix2<let A: Int, let B: Int, Scalar> = Matrix<A, B, Scalar>
/// Defines a three-dimensional matrix by storing a vector in each position.
@available(macOS 26.0, *)
public typealias Matrix3<let A: Int, let B: Int, let C: Int, Scalar> = Matrix2<A, B, Vector<C, Scalar>>
/// Defines a four-dimensional matrix by storing a matrix in each position.
@available(macOS 26.0, *)
public typealias Matrix4<let A: Int, let B: Int, let C: Int, let D: Int, Scalar> = Matrix2<A, B, Matrix2<C, D, Scalar>>

/// Rectangular array of values arranged in rows and columns.
/// - Rows: Number of rows of this matrix. Also the size of a column.
/// - Columns: Number of columns of this matrix. Also the size of a row.
/// - Scalar: Value stored inside of the matrix.
@available(macOS 26.0.0, *)
public struct Matrix<let Rows: Int, let Columns: Int, Scalar> {
    // swiftlint:disable:next missing_docs
    public typealias Index = Int
    /// Type that describes the size of the matrix.
    public typealias Size = Vector<2, Int>
    /// Type that represents a position in the matrix.
    public typealias Position = MatrixIndex<2>
    // MARK: Variables
    /// Column to row ratio of a matrix.
    public static var aspectRatio: Double { Double(Columns) / Double(Rows) }
    /// Size of the matrix.
    public static var size: Size { .init([Rows, Columns]) }
    /// Internal storage of the matrix.
    /// 
    /// Stores values in a vector of row vectors.
    public internal(set) var vectors: Vector<Rows, Vector<Columns, Scalar>>
    /// Transposed of the matrix.
    /// 
    /// Also known as the Inverse Matrix.
    public var transposed: Matrix<Columns, Rows, Scalar> { .init { self[r: $0.column, c: $0.row] } }
    // MARK: Subscripts
    /// Element in a given matrix position.
    /// - Parameter position: Position in the matrix.
    /// - Returns: Element at the given position.
    public subscript(_ position: Position) -> Scalar {
        get { vectors[position.row][position.column] }
        set { vectors[position.row][position.column] = newValue}
    }
    /// Element in a given row and column of the matrix.
    /// - Parameters:
    ///   - row: Row index.
    ///   - column: Column index.
    ///
    /// - Returns: Element at the given row and column.
    public subscript(r row: Int, c column: Int) -> Scalar {
        get { self[Position(r: row, c: column)] }
        set { self[Position(r: row, c: column)] = newValue }
    }
    /// Row of the matrix.
    /// - Parameter row: Row index.
    /// - Returns: A vector containing all of the elements in the given matrix row.
    public subscript(r row: Int) -> Vector<Columns, Scalar> {
        get { vectors[row] }
        set { vectors[row] = newValue }
    }
    /// Column of the matrix.
    /// - Parameter column: Column index.
    /// - Returns: A vector containing all of the elements in the given matrix column.
    public subscript(c column: Int) -> Vector<Rows, Scalar> {
        get { .init { self[Position(r: $0, c: column)] } }
        set { vectors.indices.forEach { self[Position(r: $0, c: column)] = newValue[$0] } }
    }
    // MARK: Initializers
    /// Creates a new matrix from a vector of row vectors.
    /// - Parameter elements: Vector of row vectors.
    public init(_ elements: Vector<Rows, Vector<Columns, Scalar>>) {
        self.vectors = elements
    }
    /// Creates a new matrix from an inline array of inline arrays.
    /// - Parameter arrays: Inline array of inline arrays, with the latter representing one row each.
    public init(_ arrays: [Rows of [Columns of Scalar]]) {
        vectors = .init { .init(arrays[$0]) }
    }
    /// Creates a new matrix by mapping a position to a value.
    /// - Parameter body: Transformation function.
    /// - Throws: Error `E` when an error in mapping is encountered.
    public init<E: Error>(_ body: (Position) throws(E) -> Scalar) rethrows {
        vectors = try .init { r in
            try .init { c in
                try body(Position(r: r, c: c))
            }
        }
    }
    /// Creates a new matrix from a sequence of ordered scalars.
    /// - Parameters:
    ///   - sequence: Sequence of ordered scalars.
    ///   - default: Fallback value used to fill value gaps.
    ///
    public init(sequence: [Scalar], default: Scalar) {
        self.init {
            let index = Self.arrayIndex(from: $0)
            return if sequence.indices.contains(index) {
                sequence[index]
            } else {
                `default`
            }
        }
    }
    // MARK: Methods
    /// Transforms the matrix into a vector by flatting columns.
    /// - Parameter transform: Flatten function.
    /// - Returns: A vector containing all flattened columns.
    /// - Throws: Error `E` when a flatten operation fails.
    func flatColumns<T, E: Error>(_ transform: (Vector<Rows, Scalar>) throws(E) -> T) rethrows -> Vector<Columns, T> {
        try .init { try transform(self[c: $0]) }
    }
    /// Transforms the matrix into a vector by flatting rows.
    /// - Parameter transform: Flatten function.
    /// - Returns: A vector containing all flattened rows.
    /// - Throws: Error `E` when a flatten operation fails.
    func flatRows<T, E: Error>(_ transform: (Vector<Columns, Scalar>) throws(E) -> T) rethrows -> Vector<Rows, T> {
        try .init { try transform(self[r: $0]) }
    }
    /// Determines the array index for a given position in the matrix.
    /// 
    /// Array indices follow all columns in a row before moving to the next row.
    /// Example: In a 2x3 matrix, the position (1, 2) has the array index of 5.
    /// - Parameter index: Position in the matrix.
    /// - Returns: Array index for the type
    static func arrayIndex(from index: Position) -> Int {
        var multiplier = 1
        var arrayIndex = 0

        for item in size.enumerated().reversed() {
            arrayIndex += index[item.offset] * multiplier
            multiplier *= item.element
        }

        return arrayIndex
    }
    /// Determines a position from a given array index.
    /// 
    /// Works as the inverse operation of `Matrix.arrayIndex(from:)`
    /// - Parameter arrayIndex: Array index.
    /// - Returns: Position in the matrix.
    static func position(from arrayIndex: Int) -> Position {
        var position = Position.zero
        var arrayIndex = arrayIndex

        for item in size.enumerated().reversed() {
            position[item.offset] = arrayIndex % item.element
            arrayIndex /= item.element
        }

        return position
    }
}

// MARK: Self: Equatable
@available(macOS 26.0.0, *)
extension Matrix: Equatable where Scalar: Equatable {}

// MARK: Self: Hashable
@available(macOS 26.0.0, *)
extension Matrix: Hashable where Scalar: Hashable {}

// MARK: Self: Sendable
@available(macOS 26.0.0, *)
extension Matrix: Sendable where Scalar: Sendable {}
