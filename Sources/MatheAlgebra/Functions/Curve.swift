//
//  Curve.swift
//  Mathe
//
//  Created by Martônio Júnior on 24/04/2026.
//

public import MatheRange

/// Curve that describes a traditional image function, assuming the field to be the entire representable range of `T`.
public typealias CurveFunction<T> = Curve<Void, T, T>
/// Defines an image function that combines a field with a input to obtain it's output.
/// 
/// This allows the construction of new values based on known inputs.
/// - `Field` works as the set of known values used by the curve.
/// - `Input` acts as the main paramter for sampling the curve.
/// - `Output` is the result of the curve's sampling.
public struct Curve<Field, Input, Value> {
    // MARK: Variables
    /// Function that represents the curve.
    var f: (Field, Input) -> Value
    // MARK: Initializers
    /// Creates a new curve from a function.
    /// - Parameter f: Function that represents the curve.
    public init(_ f: @escaping (Field, Input) -> Value) {
        self.f = f
    }
    // MARK: Methods
    /// Samples the curve using a field of possible values and input.
    /// - Parameters:
    ///   - field: Field used as the reference for the curve.
    ///   - input: Value used to sample the curve.
    ///
    /// - Returns: The sampled value from the curve.
    public func callAsFunction(_ field: Field, _ input: Input) -> Value {
        f(field, input)
    }
    /// Creates a new curve by transforming the field.
    /// - Parameter transform: Transformation function.
    /// - Returns: A new curve with a transformed field.
    public func mapField<T>(_ transform: @escaping (T) -> Field) -> Curve<T, Input, Value> {
        .init { f(transform($0), $1) }
    }
    /// Creates a new curve by transforming the input.
    /// - Parameter transform: Transformation function.
    /// - Returns: A new curve with a transformed input.
    public func mapInput<T>(_ transform: @escaping (T) -> Input) -> Curve<Field, T, Value> {
        .init { f($0, transform($1)) }
    }
    /// Creates a new curve by transforming the output.
    /// - Parameter transform: Transformation function.
    /// - Returns: A new curve with a transformed output.
    public func mapValue<T>(_ transform: @escaping (Value) -> T) -> Curve<Field, Input, T> {
        .init { transform(f($0, $1)) }
    }
}

// MARK: DotSyntax
public extension Curve where Field: Boundary, Field.Bound == Value, Input == Value {
    /// Creates a new curve using the sampling of another curve.
    /// - Parameters:
    ///   - base: Curve used as the reference for sampling
    ///   - f: Transformation applied to input before sampling
    ///
    /// - Returns: A new `Curve` that's sampled from the field using a transformed input.
    static func sampled(_ base: Self, _ f: @escaping (Input) -> Value) -> Self {
        .init { $0.sample(base, t: f($1)) }
    }
}

public extension Curve where Field: Gamut, Input == Normalized<Value> {
    /// Creates a new curve from an existing one with normalized values as input.
    /// - Parameter curve: Curve used as the base.
    /// - Returns: A new `Curve` instance with `Normalized<Value>` as the input.
    static func normalized(_ curve: Curve<Field, Value, Value>) -> Self {
        curve.mapInput(\.wrappedValue)
    }
}

public extension Curve where Field: Gamut, Input == Saturated<Value> {
    /// Creates a new curve from an existing one with saturated values as input.
    /// - Parameter curve: Curve used as the base.
    /// - Returns: A new `Curve` instance with `Saturated<Value>` as the input.
    static func saturated(_ curve: Curve<Field, Value, Value>) -> Self {
        curve.mapInput(\.wrappedValue)
    }
}

// MARK: Self.Field == Void
public extension Curve where Field == Void {
    /// Samples the curve based on a given input.
    /// - Parameter input: Value used to sample the curve.
    /// - Returns: The sampled value from the curve.
    func callAsFunction(_ input: Input) -> Value {
        f((), input)
    }
    /// Creates a new curve from a function.
    /// - Parameter f: Function that represents the curve.
    /// - Returns: A new `Curve` that does not require a field.
    static func f(_ f: @escaping (Input) -> Value) -> Self {
        .init { _, input in f(input) }
    }
}

// MARK: Boundary (EX)
/// Curve based on a Boundary
public typealias BoundaryCurve<B: Boundary, Input> = Curve<B, Input, B.Bound>

public extension Boundary {
    /// Evaluates a curve using an input.
    /// - Parameters:
    ///   - curve: Curve to be evaluated.
    ///   - t: Input used by the curve function.
    ///
    /// - Returns: A new value derived from this field and input.
    func sample<Input>(_ curve: BoundaryCurve<Self, Input>, t: Input) -> Bound {
        curve.f(self, t)
    }
}
