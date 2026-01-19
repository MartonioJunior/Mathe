//
//  Vector.swift
//  CoreCollections
//
//  Created by Martônio Júnior on 12/07/2025.
//

public import Numerics

@available(macOS 26.0, *)
public struct Vector<let N: Int, Scalar> {
    // MARK: Variables
    var elements: [N of Scalar]

    // MARK: Subscripts
    public subscript(_ index: Int) -> Scalar {
        get { elements[index] }
        set { elements[index] = newValue }
    }

    // MARK: Initializers
    public init(_ elements: [N of Scalar]) {
        self.elements = elements
    }

    public init(_ body: (Int) throws -> Scalar) rethrows {
        self.elements = try InlineArray(body)
    }

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
    public func map<T>(_ transform: (Scalar) -> T) -> Vector<N, T> {
        .init { transform(elements[$0]) }
    }
}

// MARK: DotSyntax
@available(macOS 26.0, *)
public extension Vector {
    static func repeating(_ value: @autoclosure () -> Scalar) -> Self {
        .init { _ in value() }
    }

    static func matrix<let A: Int, T>(_ matrix: [N of [A of T]]) -> Self where Scalar == Vector<A, T> {
        .init { .init(matrix[$0]) }
    }

    static func matrix<let A: Int, T>(_ matrix: [N of Vector<A, T>]) -> Self where Scalar == Vector<A, T> {
        .init { matrix[$0] }
    }

    static func matrix<let A: Int, T>(_ map: (Int, Int) -> T) -> Self where Scalar == Vector<A, T> {
        .init { index in .init { subindex in map(index, subindex) } }
    }
}

// MARK: Self: Collection
@available(macOS 26.0, *)
extension Vector: Collection {
    public var startIndex: Int { 0 }
    public var endIndex: Int { N }

    public func index(after i: Int) -> Int { i + 1 }
}

// MARK: Self: CustomStringConvertible
@available(macOS 26.0, *)
extension Vector: CustomStringConvertible {
    public var description: String {
        "(" + elements.flexible.map { "\($0)" }.joined(separator: ", ") + ")"
    }
}

// MARK: Self: Decodable
@available(macOS 26.0, *)
extension Vector: Decodable where Scalar: Decodable {
    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        elements = try .init { _ in try container.decode(Scalar.self) }
    }
}

// MARK: Self: Encodable
@available(macOS 26.0, *)
extension Vector: Encodable where Scalar: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try elements.forEach { try container.encode($0) }
    }
}

// MARK: Self: Equatable
@available(macOS 26.0, *)
extension Vector: Equatable where Scalar: Equatable {}

// MARK: Self: ExpressibleByArrayLiteral
@available(macOS 26.0, *)
extension Vector: ExpressibleByArrayLiteral where Scalar: AdditiveArithmetic {
    public init(arrayLiteral elements: Scalar...) {
        self.init(sequence: elements, default: .zero)
    }
}

// MARK: Self: Hashable
@available(macOS 26.0, *)
extension Vector: Hashable where Scalar: Hashable {
    public func hash(into hasher: inout Hasher) {
        elements.forEach {
            hasher.combine($0)
        }
    }
}

// MARK: Self: Pointwise
@available(macOS 26.0, *)
extension Vector: Pointwise {
    public var scalarCount: Int { count }

    public init(scalars: [Scalar]) {
        self.init { scalars[$0] }
    }
}

// MARK: Self: SIMD
@available(macOS 26.0, *)
extension Vector: SIMD where Scalar: SIMDScalar & AdditiveArithmetic {
    public typealias MaskStorage = Vector<N, Scalar.SIMDMaskScalar>
}

// MARK: Self: SIMDStorage
@available(macOS 26.0, *)
extension Vector: SIMDStorage where Scalar: AdditiveArithmetic & Codable & Hashable {
    public init() {
        self.init(.init(repeating: .zero))
    }
}

// MARK: Self.N == 1
@available(macOS 26.0, *)
public extension Vector where N == 1 {
    var x: Scalar {
        get { elements[0] }
        set { elements[0] = newValue }
    }
}

// MARK: Self.N == 2
@available(macOS 26.0, *)
public typealias Vector2 = Vector<2, Double>
@available(macOS 26.0, *)
public typealias Vector2Int = Vector<2, Int>

@available(macOS 26.0, *)
public extension Vector where N == 2 {
    var x: Scalar {
        get { elements[0] }
        set { elements[0] = newValue }
    }

    var y: Scalar {
        get { elements[1] }
        set { elements[1] = newValue }
    }
}

// MARK: Self.N == 3
@available(macOS 26.0, *)
public typealias Vector3 = Vector<3, Double>
@available(macOS 26.0, *)
public typealias Vector3Int = Vector<3, Int>

@available(macOS 26.0, *)
public extension Vector where N == 3 {
    var x: Scalar {
        get { elements[0] }
        set { elements[0] = newValue }
    }

    var y: Scalar {
        get { elements[1] }
        set { elements[1] = newValue }
    }

    var z: Scalar {
        get { elements[2] }
        set { elements[2] = newValue }
    }

    func cross(_ rhs: Self) -> Self where Scalar: Numeric {
        .init([
            y * rhs.z - z * rhs.y,
            z * rhs.x - x * rhs.z,
            x * rhs.y - y * rhs.x
        ])
    }
}

// MARK: Self.N == 4
@available(macOS 26.0, *)
public typealias Vector4 = Vector<4, Double>
@available(macOS 26.0, *)
public typealias Vector4Int = Vector<4, Int>
@available(macOS 26.0, *)
public typealias Quaternion<T> = Vector<4, T>

@available(macOS 26.0, *)
public extension Vector where N == 4 {
    var x: Scalar {
        get { elements[0] }
        set { elements[0] = newValue }
    }

    var y: Scalar {
        get { elements[1] }
        set { elements[1] = newValue }
    }

    var z: Scalar {
        get { elements[2] }
        set { elements[2] = newValue }
    }

    var w: Scalar {
        get { elements[3] }
        set { elements[3] = newValue }
    }
}

// MARK: Scalar: AdditiveArithmetic
@available(macOS 26.0, *)
public extension Vector where Scalar: AdditiveArithmetic {
    init(sequence elements: [Scalar]) {
        self.init(sequence: elements, default: .zero)
    }
}

// MARK: Scalar: ExpressibleByIntegerLiteral
@available(macOS 26.0, *)
public extension Vector where Scalar: ExpressibleByIntegerLiteral {
    static var one: Self { .repeating(1) }
}

// MARK: Scalar: FloatingPoint
@available(macOS 26.0, *)
public extension Vector where Scalar: FloatingPoint & ElementaryFunctions {
    static func / (lhs: Self, rhs: Scalar) -> Self {
        Self { rhs == 0 ? .nan : lhs[$0] / rhs }
    }

    var normalized: Self {
        let magnitude = self.magnitude
        return if magnitude != 0 {
            self / magnitude
        } else {
            self
        }
    }

    func othorgonalProjection(on vector: Self) -> Scalar {
        let m = magnitude
        let distance = (dot(vector) / (m * vector.magnitude)) * m
        return distance.isNaN ? 0 : distance
    }
}

// MARK: Self.Scalar: Numeric
@available(macOS 26.0, *)
public extension Vector where Scalar: Numeric & Comparable & ElementaryFunctions {
    var magnitude: Scalar { Scalar.root(dot(self), 2) }
}
