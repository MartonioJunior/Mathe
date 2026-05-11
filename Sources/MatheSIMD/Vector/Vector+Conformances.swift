//
//  Vector+Conformances.swift
//  Mathe
//
//  Created by Martônio Júnior on 11/05/2026.
//

// MARK: Self: Collection
@available(macOS 26.0, *)
extension Vector: Collection {
    // swiftlint:disable:next missing_docs
    public var startIndex: Int { 0 }
    // swiftlint:disable:next missing_docs
    public var endIndex: Int { N }
    // swiftlint:disable:next missing_docs
    public func index(after i: Int) -> Int { i + 1 }
}

// MARK: Self: CustomStringConvertible
@available(macOS 26.0, *)
extension Vector: CustomStringConvertible {
    // swiftlint:disable:next missing_docs
    public var description: String {
        "(" + elements.flexible.map { "\($0)" }.joined(separator: ", ") + ")"
    }
}

// MARK: Self: Decodable
@available(macOS 26.0, *)
extension Vector: Decodable where Scalar: Decodable {
    // swiftlint:disable:next missing_docs
    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        elements = try .init { _ in try container.decode(Scalar.self) }
    }
}

// MARK: Self: Encodable
@available(macOS 26.0, *)
extension Vector: Encodable where Scalar: Encodable {
    // swiftlint:disable:next missing_docs
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try elements.forEach { try container.encode($0) }
    }
}

// MARK: Self: ExpressibleByArrayLiteral
@available(macOS 26.0, *)
extension Vector: ExpressibleByArrayLiteral where Scalar: AdditiveArithmetic {
    // swiftlint:disable:next missing_docs
    public init(arrayLiteral elements: Scalar...) {
        self.init(sequence: elements, default: .zero)
    }
}

// MARK: Self: Hashable
@available(macOS 26.0, *)
extension Vector: Hashable where Scalar: Hashable {
    // swiftlint:disable:next missing_docs
    public func hash(into hasher: inout Hasher) {
        elements.forEach {
            hasher.combine($0)
        }
    }
}

// MARK: Self: Pointwise
@available(macOS 26.0, *)
extension Vector: Pointwise {
    // swiftlint:disable:next missing_docs
    public var scalarCount: Int { count }
    /// Creates a new instance based on it's scalar components.
    /// Parameter scalars: List of scalar components that compose the type.
    /// 
    /// If the list of scalars is smaller than the vector size, throws an error at runtime.
    public init(scalars: [Scalar]) {
        self.init { scalars[$0] }
    }
}

// MARK: Self: SIMD
@available(macOS 26.0, *)
extension Vector: SIMD where Scalar: SIMDScalar & AdditiveArithmetic {
    // swiftlint:disable:next missing_docs
    public typealias MaskStorage = Vector<N, Scalar.SIMDMaskScalar>
}

// MARK: Self: SIMDStorage
@available(macOS 26.0, *)
extension Vector: SIMDStorage where Scalar: AdditiveArithmetic & Codable & Hashable {
    // swiftlint:disable:next missing_docs
    public init() {
        self.init(.init(repeating: .zero))
    }
}
