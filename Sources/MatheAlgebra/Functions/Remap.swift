//
//  Remap.swift
//  Mathe
//
//  Created by Martônio Júnior on 24/04/2026.
//

public import MatheRange

/// Defines a function that transforms values between fields.
/// - `Origin`: Field where the value exists.
/// - `Target`: Field where the value will be mapped to.
/// - `Input`: Value in the origin field.
/// - `Output`: Value in the target field.
public struct Remap<Origin, Target, Input, Output> {
    // MARK: Variables
    var f: (Origin, Target, Input) -> Output
    // MARK: Initializers
    /// Creates a new mapper from a function.
    /// - Parameter f: Remapping function.
    public init(_ f: @escaping (Origin, Target, Input) -> Output) {
        self.f = f
    }
    /// Creates a new mapper by combining two curves:
    /// 
    /// The first curve is used to generate a base value based on origin field and input,
    /// while the second one builds the final output using the target field and base value.
    /// - Parameters:
    ///   - prediction: First curve, used to obtain the base value.
    ///   - interpolation: Second curve, used to obtain the final result.
    ///
    public init<Value>(
        _ prediction: Curve<Origin, Input, Value>,
        interpolation: Curve<Target, Value, Output>
    ) {
        self.init { interpolation.f($1, prediction.f($0, $2)) }
    }
}

// MARK: Boundary (EX)
/// Remapper based on a pair of boundaries
public typealias BoundaryRemap<B1: Boundary, B2: Boundary> = Remap<B1, B2, B1.Bound, B2.Bound>

public extension Boundary {
    /// Remaps a value from the current boundary to a new field using a remapper.
    /// - Parameters:
    ///   - value: Value to be remapped.
    ///   - newBoundary: Target boundary for the new value.
    ///   - algorithm: Remapper used by the conversion.
    ///
    /// - Returns: A new value based on the target boundary.
    func remap<T: Boundary>(
        _ value: Bound,
        to newBoundary: T,
        using algorithm: BoundaryRemap<Self, T>
    ) -> T.Bound {
        algorithm.f(self, newBoundary, value)
    }
}
