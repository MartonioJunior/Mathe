//
//  Matrix+Conformances.swift
//  Mathe
//
//  Created by Martônio Júnior on 11/05/2026.
//

// MARK: Self: Collection
@available(macOS 26.0.0, *)
extension Matrix: Collection {
    // swiftlint:disable:next missing_docs
    public var startIndex: Index { 0 }
    // swiftlint:disable:next missing_docs
    public var endIndex: Index { scalarCount }
    // swiftlint:disable:next missing_docs
    public func index(after i: Index) -> Index { i + 1 }
}

// MARK: Self: CustomStringConvertible
@available(macOS 26.0, *)
extension Matrix: CustomStringConvertible {
    // swiftlint:disable:next missing_docs
    public var description: String {
        vectors.map { "[\($0)]" }.joined(separator: "\n")
    }
}

// MARK: Self: Decodable
@available(macOS 26.0, *)
extension Matrix: Decodable where Scalar: Decodable {
    // swiftlint:disable:next missing_docs
    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        vectors = try .init { _ in try container.decode(Vector<Columns, Scalar>.self) }
    }
}

// MARK: Self: Encodable
@available(macOS 26.0, *)
extension Matrix: Encodable where Scalar: Encodable {
    // swiftlint:disable:next missing_docs
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try vectors.forEach { try container.encode($0) }
    }
}



// MARK: Self: ExpressibleByArrayLiteral
@available(macOS 26.0, *)
extension Matrix: ExpressibleByArrayLiteral where Scalar: AdditiveArithmetic {
    // swiftlint:disable:next missing_docs
    public init(arrayLiteral elements: Scalar...) {
        self.init(sequence: elements, default: .zero)
    }
}

// MARK: Self: MutableCollection
@available(macOS 26.0.0, *)
extension Matrix: MutableCollection {}

// MARK: Self: Pointwise
@available(macOS 26.0.0, *)
extension Matrix: Pointwise {
    // swiftlint:disable:next missing_docs
    public var scalarCount: Int { Self.size.x * Self.size.y }
    // swiftlint:disable:next missing_docs
    public subscript(index: Index) -> Scalar {
        get { self[Self.position(from: index)] }
        set { self[Self.position(from: index)] = newValue}
    }
    // swiftlint:disable:next missing_docs
    public init(scalars: [Scalar]) {
        self.init { scalars[Self.arrayIndex(from: $0)] }
    }
}

// MARK: Self: SIMD
@available(macOS 26.0, *)
extension Matrix: SIMD where Scalar: SIMDScalar & AdditiveArithmetic {
    // swiftlint:disable:next missing_docs
    public typealias MaskStorage = Matrix<Rows, Columns, Scalar.SIMDMaskScalar>
}

// MARK: Self: SIMDStorage
@available(macOS 26.0, *)
extension Matrix: SIMDStorage where Scalar: AdditiveArithmetic & Codable & Hashable {
    // swiftlint:disable:next missing_docs
    public init() {
        self = .repeating(.zero)
    }
}
