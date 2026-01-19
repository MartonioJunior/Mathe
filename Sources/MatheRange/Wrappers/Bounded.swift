//
//  Bounded.swift
//  Mathe
//
//  Created by Martônio Júnior on 19/01/2026.
//

@propertyWrapper
public struct Bounded<B: Boundary> {
    // MARK: Variables
    var boundary: B
    var rawValue: B.Bound

    public var wrappedValue: B.Bound { rawValue }

    // MARK: Initializers
    public init?(wrappedValue: B.Bound, in boundary: B) {
        guard boundary.contains(wrappedValue) else { return nil }

        self.boundary = boundary
        rawValue = wrappedValue
    }

    // MARK: Methods
    public mutating func updateValue(_ newValue: B.Bound) {
        guard boundary.contains(newValue) else { return }

        rawValue = newValue
    }
}

// MARK: Self.B: Floor
public extension Bounded {
    static func positive<Value: AdditiveArithmetic>(_ value: Value) -> Self? where B == PartialRangeFrom<Value> {
        .init(wrappedValue: value, in: .zero...)
    }
}

// MARK: Self.B: Ceiling
public extension Bounded {
    static func negative<Value: AdditiveArithmetic>(_ value: Value) -> Self? where B == PartialRangeUpTo<Value> {
        .init(wrappedValue: value, in: ..<(.zero))
    }
}
