//
//  Saturated.swift
//  Mathe
//
//  Created by Martônio Júnior on 02/05/2026.
//

import MatheRange

/// Data structure that represents a value that exists in the 0...1 range
@propertyWrapper
public struct Saturated<Value: Numeric & Comparable> {
    // MARK: Variables
    var rawValue: Value
    /// Returns a value in the 0...1 range.
    public var wrappedValue: Value {
        get { rawValue }
        set { rawValue = newValue.saturated }
    }
    // MARK: Initializers
    /// Creates a new saturated value by clamping the current one.
    /// - Parameter value: Value to be clamped.
    public init(clamped value: Value) {
        rawValue = value.saturated
    }
}

// MARK: Self: ExpressibleByIntegerLiteral
extension Saturated: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {
    /// Creates a new saturated value by clamping the current one.
    /// - Parameter value: Value to be clamped.
    public init(integerLiteral value: Value.IntegerLiteralType) {
        self.init(clamped: Value(integerLiteral: value))
    }
}

// MARK: Self: ExpressibleByFloatLiteral
extension Saturated: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {
    /// Creates a new saturated value by clamping the current one.
    /// - Parameter value: Value to be clamped.
    public init(floatLiteral value: Value.FloatLiteralType) {
        self.init(clamped: Value(floatLiteral: value))
    }
}

// MARK: Self.Value: FloatingPoint
public extension Saturated where Value: FloatingPoint {
    /// Creates a new saturated value by looping the current one.
    /// - Parameter value: Value to be used as the base.
    init(looping value: Value) {
        self.init(clamped: value.truncatingRemainder(dividingBy: 1))
    }
}

// MARK: Self.Value: SignedNumeric
public extension Saturated where Value: SignedNumeric {
    /// Remaps the current value from 0...1 to -1...1 range.
    var normalized: Normalized<Value> { .init(clamped: wrappedValue * 2 - 1) }
}

// MARK: Numeric (EX)
public extension Numeric where Self: Comparable {
    /// Returns the value clamped to the 0...1 range.
    var saturated: Self { (0...1).clamp(self) }
}
