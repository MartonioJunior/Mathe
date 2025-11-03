//
//  Matrix+Utilities.swift
//  Trinkets
//
//  Created by Martônio Júnior on 06/10/2025.
//

// MARK: Matrix NxN
@available(macOS 26.0.0, *)
public extension Matrix where Columns == Rows {
    static func squareMatrix(_ vector: Vector<Rows, Vector<Columns, Element>>) -> Self {
        .init(vector)
    }
}

// MARK: Matrix Nx1
@available(macOS 26.0.0, *)
public extension Matrix where Columns == 1 {
    static func columnMatrix(_ vector: Vector<Rows, Element>) -> Self {
        .init { vector[$0[0]] }
    }

    static func transposed(_ vector: Vector<Rows, Element>) -> Self {
        .columnMatrix(vector)
    }
}

// MARK: Matrix 1xN
@available(macOS 26.0.0, *)
public extension Matrix where Rows == 1 {
    static func rowMatrix(_ vector: Vector<Columns, Element>) -> Self {
        .init { vector[$0[0]] }
    }
}

@available(macOS 26.0.0, *)
public extension Matrix where Rows == 1, Element: Numeric {
    var determinant: Element { self[r: 0, c: 0] }
}

// MARK: Matrix 2x2
@available(macOS 26.0.0, *)
public extension Matrix where Rows == 2, Columns == 2, Element: Numeric {
    var determinant: Element {
        let a = self[r: 0, c: 0]
        let b = self[r: 0, c: 1]
        let c = self[r: 1, c: 0]
        let d = self[r: 1, c: 1]
        return a * d - b * c
    }
}

// MARK: Matrix 4x4
@available(macOS 26.0.0, *)
public extension Matrix where Rows == 4, Columns == 4, Element: Numeric {
    static func trs(_ translate: Self, _ rotate: Self, _ scale: Self) -> Self {
        translate * rotate * scale
    }

    func scaled(_ vector: Vector<3, Element>) -> Self {
        var matrix = self
        matrix[12] = vector.x
        matrix[13] = vector.y
        matrix[14] = vector.z
        return matrix
    }

    func translated(by vector: Vector<3, Element>) -> Self {
        var matrix = self
        matrix[3] += vector.x
        matrix[7] += vector.y
        matrix[11] += vector.z
        return matrix
    }
}

// MARK: Self.Element: AdditiveArithmetic
@available(macOS 26.0, *)
public extension Matrix where Element: AdditiveArithmetic {
    public init(sequence elements: [Element]) {
        self.init(sequence: elements, default: .zero)
    }
}

// MARK: Self.Element: ExpressibleByIntegerLiteral
@available(macOS 26.0, *)
public extension Matrix where Element: ExpressibleByIntegerLiteral {
    static var one: Self { .repeating(1) }
}

// MARK: Self.Element: Numeric
@available(macOS 26.0.0, *)
public extension Matrix where Element: Numeric {
    static var identity: Self { .init { $0.row == $0.column ? 1 : 0 } }

    static func * <let N: Int>(lhs: Self, rhs: Matrix<Columns, N, Element>) -> Matrix<Rows, N, Element> {
        .init {
            let row = lhs[r: $0.row]
            let column = rhs[c: $0.column]
            return row.dot(column)
        }
    }
}
