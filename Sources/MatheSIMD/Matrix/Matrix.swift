//
//  Matrix.swift
//  Trinkets
//
//  Created by Martônio Júnior on 25/04/25.
//

@available(macOS 26.0, *)
public typealias Matrix2<let A: Int, let B: Int, Scalar> = Matrix<A, B, Scalar>
@available(macOS 26.0, *)
public typealias Matrix3<let A: Int, let B: Int, let C: Int, Scalar> = Matrix2<A, B, Vector<C, Scalar>>
@available(macOS 26.0, *)
public typealias Matrix4<let A: Int, let B: Int, let C: Int, let D: Int, Scalar> = Matrix2<A, B, Matrix2<C, D, Scalar>>

@available(macOS 26.0.0, *)
public struct Matrix<let Rows: Int, let Columns: Int, Element> {
    public typealias Index = Int
    public typealias Size = Vector<2, Int>
    public typealias Position = MatrixIndex<2>

    // MARK: Variables
    var spaces: Vector<Rows, Vector<Columns, Element>>

    public static var aspectRatio: Double { Double(Columns) / Double(Rows) }
    public static var size: Size { .init([Rows, Columns]) }

    /// Also known as the Inverse Matrix
    var transposed: Matrix<Columns, Rows, Element> { .init { self[r: $0.column, c: $0.row] } }

    // MARK: Subscripts
    public subscript(_ position: Position) -> Element {
        get { spaces[position.row][position.column] }
        set { spaces[position.row][position.column] = newValue}
    }

    public subscript(r row: Int, c column: Int) -> Element {
        get { self[Position(r: row, c: column)] }
        set { self[Position(r: row, c: column)] = newValue }
    }

    public subscript(r row: Int) -> Vector<Columns, Element> {
        get { spaces[row] }
        set { spaces[row] = newValue }
    }

    public subscript(c column: Int) -> Vector<Rows, Element> {
        get { .init { self[Position(r: $0, c: column)] } }
        set { spaces.indices.forEach { self[Position(r: $0, c: column)] = newValue[$0] } }
    }

    // MARK: Initializers
    public init(_ elements: Vector<Rows, Vector<Columns, Element>>) {
        self.spaces = elements
    }

    public init(_ arrays: [Rows of [Columns of Element]]) {
        spaces = .init { .init(arrays[$0]) }
    }

    public init(_ body: (Position) throws -> Element) rethrows {
        spaces = try .init { r in
            try .init { c in
                try body(Position(r: r, c: c))
            }
        }
    }

    public init(sequence: [Element], default: Element) {
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
    // size = [2, 3], index = [1, 2]
    // index.row * size.x + index.column -> arrayIndex = 5
    static func arrayIndex(from index: Position) -> Int {
        var multiplier = 1
        var arrayIndex = 0

        for item in size.enumerated().reversed() {
            arrayIndex += index[item.offset] * multiplier
            multiplier *= item.element
        }

        return arrayIndex
    }

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

// MARK: DotSyntax
@available(macOS 26.0.0, *)
public extension Matrix {
    static func repeating(_ value: @autoclosure () -> Element) -> Self {
        .init { _ in value() }
    }

    static func composite<let A: Int, T>(
        _ matrix: [Rows of [Columns of [A of T]]]
    ) -> Self where Element == Vector<A, T> {
        .init { .init(matrix[$0.row][$0.column]) }
    }

    static func composite<let A: Int, T>(
        _ matrix: [Rows of [Columns of Vector<A, T>]]
    ) -> Self where Element == Vector<A, T> {
        .init { matrix[$0.row][$0.column] }
    }

    static func composite<let A: Int, let B: Int, T>(
        _ matrix: [Rows of [Columns of Matrix<A, B, T>]]
    ) -> Self where Element == Matrix<A, B, T> {
        .init { matrix[$0.row][$0.column] }
    }

    static func composite<let A: Int, T>(
        _ map: (Position, Int) -> T
    ) -> Self where Element == Vector<A, T> {
        .init { index in .init { subindex in map(index, subindex) } }
    }

    static func composite<let A: Int, let B: Int, T>(
        _ map: (Position, Position) -> T
    ) -> Self where Element == Matrix<A, B, T> {
        .init { index in .init { subindex in map(index, subindex) } }
    }
}

// MARK: Self: Collection
@available(macOS 26.0.0, *)
extension Matrix: Collection {
    public var startIndex: Index { 0 }
    public var endIndex: Index { scalarCount }

    public func index(after i: Index) -> Index { i + 1 }
}

// MARK: Self: CustomStringConvertible
@available(macOS 26.0, *)
extension Matrix: CustomStringConvertible {
    public var description: String {
        spaces.map { "[\($0)]" }.joined(separator: "\n")
    }
}

// MARK: Self: Decodable
@available(macOS 26.0, *)
extension Matrix: Decodable where Element: Decodable {
    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        spaces = try .init { _ in try container.decode(Vector<Columns, Element>.self)  }
    }
}

// MARK: Self: Encodable
@available(macOS 26.0, *)
extension Matrix: Encodable where Element: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try spaces.forEach { try container.encode($0) }
    }
}

// MARK: Self: Equatable
@available(macOS 26.0.0, *)
extension Matrix: Equatable where Element: Equatable {}

// MARK: Self: ExpressibleByArrayLiteral
@available(macOS 26.0, *)
extension Matrix: ExpressibleByArrayLiteral where Element: AdditiveArithmetic {
    public init(arrayLiteral elements: Element...) {
        self.init(sequence: elements, default: .zero)
    }
}

// MARK: Self: Hashable
@available(macOS 26.0.0, *)
extension Matrix: Hashable where Element: Hashable {}

// MARK: Self: MutableCollection
@available(macOS 26.0.0, *)
extension Matrix: MutableCollection {}

// MARK: Self: Pointwise
@available(macOS 26.0.0, *)
extension Matrix: Pointwise {
    public var scalarCount: Int { Self.size.x * Self.size.y }

    public subscript(index: Index) -> Element {
        get { self[Self.position(from: index)] }
        set { self[Self.position(from: index)] = newValue}
    }

    public init(scalars: [Element]) {
        self.init { scalars[Self.arrayIndex(from: $0)] }
    }
}

// MARK: Self: SIMD
@available(macOS 26.0, *)
extension Matrix: SIMD where Element: SIMDScalar & AdditiveArithmetic {
    public typealias MaskStorage = Matrix<Rows, Columns, Scalar.SIMDMaskScalar>
}

// MARK: Self: SIMDStorage
@available(macOS 26.0, *)
extension Matrix: SIMDStorage where Element: AdditiveArithmetic & Codable & Hashable {
    public init() {
        self = .repeating(.zero)
    }
}
