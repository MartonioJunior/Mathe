//
//  Curve.swift
//  Mathe
//
//  Created by Martônio Júnior on 24/04/2026.
//

public import MatheRange

/// Curve that describes a traditional image function, assuming the field to be the entire representable universe of `T`.
public typealias CurveOf<Input, Value> = Curve<UniverseBoundary<Input>, Value>
/// Image of an interval to a topological field by a continuous function.
/// 
/// This allows the construction of new values based on known inputs.
/// - `Field` works as the set of known values used by the curve.
/// - `Output` is the result of the curve's sampling.
public struct Curve<Field: Boundary, Value> {
    /// Type representing the sampling input of the curve.
    public typealias Input = Field.Bound
    // MARK: Variables
    /// Boundary the curve exists on.
    var field: Field
    /// Function that represents the curve.
    var f: (Field, Input) -> Value
    // MARK: Initializers
    /// Creates a new curve from a field and function.
    /// - Parameters:
    ///   - field: Boundary the curve exists on.
    ///   - f: Function that represents the curve.
    public init(
        _ field: Field,
        f: @escaping (Field, Input) -> Value
    ) {
        self.field = field
        self.f = f
    }
    // MARK: Methods
    /// Samples the curve using a field of possible values and input.
    /// - Parameters:
    ///   - input: Value used to sample the curve.
    ///
    /// - Returns: The sampled value from the curve.
    public func callAsFunction(_ input: Input) -> Value {
        f(field, input)
    }

    public func mapField(
        _ transform: (Field) -> Field
    ) -> Self {
        .init(transform(field), f: f)
    }
    /// Creates a new curve by transforming the input.
    /// - Parameter transform: Transformation function.
    /// - Returns: A new curve with a transformed input.
    public func mapInput<T>(
        _ transform: @escaping (T) -> Input,
    ) -> Curve<UniverseBoundary<T>, Value> {
        .init(.init()) { f(field, transform($1)) }
    }
    /// Creates a new curve by transforming the output.
    /// - Parameter transform: Transformation function.
    /// - Returns: A new curve with a transformed output.
    public func mapValue<T>(_ transform: @escaping (Value) -> T) -> Curve<Field, T> {
        .init(field) { transform(f($0, $1)) }
    }

    public func pullback<Target: Boundary>(
        _ other: Curve<Target, Input>
    ) -> Curve<Target, Value> {
        other.remap(self)
    }
    /// Creates a new curve by using it's output in another curve.
    /// 
    /// The first curve is used to generate a value based on an origin field and input,
    /// while the second one builds the final output using the target field and output of the first curve.
    /// - Parameters:
    ///   - other: Curve that transforms the output of the first one.
    /// - Returns: Transformed curve.
    public func remap<Target: Boundary, T>(
        _ other: Curve<Target, T>
    ) -> Curve<Field, T> where Value == Target.Bound {
        mapValue { other.callAsFunction($0) }
    }
}

// MARK: DotSyntax
public extension Curve {
    /// Creates a new curve based on a function where the field's boundary acts as a mask.
    /// - Parameters:
    ///   - field: Field used as the reference
    ///   - f: Transformation applied to input before sampling
    ///
    /// - Returns: A `Curve` that's sampled from the field using a transformed input,
    /// returning `nil` for any inputs outside of the field's boundary.
    static func bounded(_ field: Field, f: @escaping (Input) -> Value) -> Curve<Field, Value?> {
        .init(field) {
            guard $0.contains($1) else { return nil }

            return f($1)
        }
    }
    /// Creates a new curve from an existing one with normalized values as input.
    /// - Parameter curve: Curve used as the base.
    /// - Returns: A new `Curve` instance with `Normalized<Value>` as the input.
    static func normalized<T>(_ curve: CurveOf<T, Value>) -> Self where Field == UniverseBoundary<Normalized<T>> {
        curve.mapInput(\.wrappedValue)
    }
    /// Creates a new curve from an existing one with saturated values as input.
    /// - Parameter curve: Curve used as the base.
    /// - Returns: A new `Curve` instance with `Saturated<Value>` as the input.
    static func saturated<T>(_ curve: CurveOf<T, Value>) -> Self where Field == UniverseBoundary<Saturated<T>> {
        curve.mapInput(\.wrappedValue)
    }
}

// MARK: Self.Field == EmptyBoundary
public extension Curve {
    /// Creates a curve that always returns a `nil` value
    /// - Parameters:
    ///
    /// - Returns:
    static func empty<T>() -> Curve<Field, Value?> where Field == EmptyBoundary<T> {
        .init(.init()) { _, _ in nil }
    }
}

// MARK: Self.Field == UniverseBoundary
public extension Curve {
    /// Creates a new curve from a function.
    /// - Parameter f: Function that represents the curve.
    /// - Returns: A new `Curve` that does not require a field.
    static func f<T>(_ f: @escaping (Input) -> Value) -> Self where Field == UniverseBoundary<T> {
        .init(.init()) { f($1) }
    }
}
