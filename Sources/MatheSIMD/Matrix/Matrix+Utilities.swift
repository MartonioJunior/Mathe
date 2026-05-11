//
//  Matrix+Utilities.swift
//  Trinkets
//
//  Created by Martônio Júnior on 06/10/2025.
//

// MARK: Matrix NxN
@available(macOS 26.0.0, *)
public extension Matrix where Columns == Rows {
    /// Diagonal for this matrix.
    var diagonal: Vector<Rows, Scalar> {
        .init { self[r: $0, c: $0] }
    }
    /// Creates a new square matrix from a vector of row vectors.
    /// - Parameter vector: Vector of row vectors.
    /// - Returns: A new NxN matrix.
    static func squareMatrix(_ vector: Vector<Rows, Vector<Columns, Scalar>>) -> Self {
        .init(vector)
    }
}

// MARK: Matrix Nx1
@available(macOS 26.0.0, *)
public extension Matrix where Columns == 1 {
    /// Creates a column vector matrix.
    /// - Parameter vector: Vector to be used as the base.
    /// - Returns: Nx1 matrix composed of `vector` components.
    static func columnMatrix(_ vector: Vector<Rows, Scalar>) -> Self {
        .init { vector[$0[0]] }
    }
    /// Transposes a vector as a column.
    /// - Parameter vector: Vector to be used as the base.
    /// - Returns: Nx1 matrix composed of `vector` components.
    static func transposed(_ vector: Vector<Rows, Scalar>) -> Self {
        .columnMatrix(vector)
    }
}

// MARK: Matrix 1xN
@available(macOS 26.0.0, *)
public extension Matrix where Rows == 1 {
    /// 1xN matrix as a vector.
    var asVector: Vector<Columns, Scalar> { vectors[0] }
    /// Creates a row vector matrix
    /// - Parameter vector: Vector to be used as the base.
    /// - Returns: 1xN matrix composed of `vector` components.
    static func rowMatrix(_ vector: Vector<Columns, Scalar>) -> Self {
        .init { vector[$0[0]] }
    }
}

@available(macOS 26.0.0, *)
public extension Matrix where Rows == 1, Scalar: Numeric {
    /// Determinant in a single element or row matrix.
    var determinant: Scalar { self[r: 0, c: 0] }
}

// MARK: Matrix 2x2
@available(macOS 26.0.0, *)
public extension Matrix where Rows == 2, Columns == 2, Scalar: Numeric {
    /// Determinant in a 2x2 matrix.
    var determinant: Scalar {
        let a = self[r: 0, c: 0]
        let b = self[r: 0, c: 1]
        let c = self[r: 1, c: 0]
        let d = self[r: 1, c: 1]
        return a * d - b * c
    }
}

// MARK: Matrix 4x4
@available(macOS 26.0.0, *)
public extension Matrix where Rows == 4, Columns == 4, Scalar: Numeric {
    /// Creates a transform-rotation-scale matrix by combining it's matrices
    /// - Parameters:
    ///   - translate: Translation matrix.
    ///   - rotate: Rotation matrix.
    ///   - scale: Scale matrix.
    ///
    /// - Returns: A new 4x4 matrix that combines the 3 matrices.
    static func trs(_ translate: Self, _ rotate: Self, _ scale: Self) -> Self {
        translate * rotate * scale
    }
    /// Creates a scale matrix.
    /// - Parameter vector: Scale vector.
    /// - Returns: The matrix with scale components.
    static func scaleMatrix(_ vector: Vector<3, Scalar>) -> Self {
        var matrix = identity
        for i in vector.scalarIndices {
            matrix[r: 3, c: i] = vector[i]
        }
        return matrix
    }
    /// Creates a translation matrix.
    /// - Parameter vector: Translation matrix.
    /// - Returns: The matrix with translation components.
    static func translationMatrix(by vector: Vector<3, Scalar>) -> Self {
        var matrix = identity
        for i in vector.scalarIndices {
            matrix[r: i, c: 3] = vector[i]
        }
        return matrix
    }
}

// MARK: Self.Scalar: AdditiveArithmetic
@available(macOS 26.0, *)
public extension Matrix where Scalar: AdditiveArithmetic {
    /// Matrix where all elements are zero.
    static var zero: Self { .init { _ in .zero } }
    /// Creates a new matrix from a sequence of ordered scalars.
    /// - Parameter elements: Sequence of ordered scalars.
    /// 
    /// If the sequence doesn't have a value to a given position, it's filled with `.zero`.
    init(sequence elements: [Scalar]) {
        self.init(sequence: elements, default: .zero)
    }
    /// Creates a diagonal matrix.
    /// - Parameter vector: Elements in the main diagonal.
    /// - Returns: Matrix with the given `vector` as it's diagonal.
    /// If the matrix is non-square, only fills values until the vector or diagonal ends, whichever comes first.
    static func diagonalMatrix(_ vector: Vector<Rows, Scalar>) -> Self {
        .init { $0.row == $0.column ? vector[$0.row] : .zero }
    }
}

// MARK: Self.Scalar: ExpressibleByIntegerLiteral
@available(macOS 26.0, *)
public extension Matrix where Scalar: ExpressibleByIntegerLiteral {
    /// Identity matrix.
    static var identity: Self { .init { $0.row == $0.column ? 1 : 0 } }
    /// Matrix where all elements are one.
    static var one: Self { .repeating(1) }
}

// MARK: Self.Scalar: Numeric
@available(macOS 26.0.0, *)
public extension Matrix where Scalar: Numeric {
    /// Multiplies a matrix RxC against a CxN matrix.
    /// - Parameters:
    ///   - lhs: A matrix.
    ///   - rhs: Another matrix
    ///
    /// - Returns: A new RxN matrix with the products of columns and rows.
    static func * <let N: Int>(lhs: Self, rhs: Matrix<Columns, N, Scalar>) -> Matrix<Rows, N, Scalar> {
        .init {
            let row = lhs[r: $0.row]
            let column = rhs[c: $0.column]
            return row.dot(column)
        }
    }
}

// MARK: Vector (EX)
@available(macOS 26.0, *)
public extension Vector where Scalar: Numeric {
    /// Multiplies a N-dimensional vector against a NxA matrix
    /// - Parameters:
    ///   - lhs: A vector.
    ///   - rhs: A matrix.
    ///
    /// - Returns: An A-dimensional vector.
    static func * <let A: Int>(lhs: Self, rhs: Matrix<N, A, Scalar>) -> Vector<A, Scalar> {
        (Matrix.rowMatrix(lhs) * rhs).asVector
    }
}
