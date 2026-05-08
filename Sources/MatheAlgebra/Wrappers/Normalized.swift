//
//  Normalized.swift
//  Mathe
//
//  Created by Martônio Júnior on 02/05/2026.
//

import MatheRange

/// Data structure that represents a value that exists in the -1...1 range
@propertyWrapper
public struct Normalized<Value: SignedNumeric & Comparable> {
    // MARK: Variables
    var rawValue: Value
    /// Value in the 0...1 range
    public var wrappedValue: Value {
        get { rawValue }
        set { rawValue = newValue.normalized }
    }
    // MARK: Initializers
    /// Creates a new normalized value by clamping the current one.
    /// - Parameter value: Value to be clamped.
    public init(clamped value: Value) {
        rawValue = value.normalized
    }
}

// MARK: Self: ExpressibleByIntegerLiteral
extension Normalized: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {
    /// Creates a new normalized value by clamping the current one.
    /// - Parameter value: Value to be clamped
    public init(integerLiteral value: Value.IntegerLiteralType) {
        self.init(clamped: Value(integerLiteral: value))
    }
}

// MARK: Self: ExpressibleByFloatLiteral
extension Normalized: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {
    /// Creates a new normalized value by clamping the current one.
    /// - Parameter value: Value to be clamped
    public init(floatLiteral value: Value.FloatLiteralType) {
        self.init(clamped: Value(floatLiteral: value))
    }
}

// MARK: SignedNumeric (EX)
public extension SignedNumeric where Self: Comparable {
    /// Returns the value clamped to the -1...1 range.
    var normalized: Self { (-1...1).clamp(self) }
}
