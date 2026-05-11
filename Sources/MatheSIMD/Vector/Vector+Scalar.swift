//
//  Vector+Constants.swift
//  Mathe
//
//  Created by Martônio Júnior on 02/05/2026.
//

// MARK: Self.Scalar: AdditiveArithmetic
@available(macOS 26.0, *)
public extension Vector where Scalar: AdditiveArithmetic {
    /// The zero value.
    /// 
    /// Zero is the identity element for addition. For any value, x + .zero == x and .zero + x == x.
    static var zero: Self { .repeating(.zero) }
    /// Creates a new instance based on it's scalar components.
    /// - Parameter elements: List of scalar components that compose the type.
    /// 
    /// If the list of scalars is smaller than the vector, assigns `.zero` for the component.
    init(sequence elements: [Scalar]) {
        self.init(sequence: elements, default: .zero)
    }
    /// Creates a new basis vector.
    /// - Parameters:
    ///   - index: Relevant index of the basis.
    ///   - value: Scalar to be used for the relevant index.
    ///
    /// - Returns: A new basis vector with `value` in it's most relevant index and `.zero` everywhere else.
    static func basis(_ index: Int, value: Scalar) -> Self {
        .basis(index, value: value, fallback: .zero)
    }
    /// Applies a mask to a vector
    /// - Parameters:
    ///   - lhs: Vector to be masked.
    ///   - rhs: Mask to be applied.
    ///
    /// - Returns: A new vector with the masked and replaced components, where the fallback is `.zero`.
    static func & (lhs: Self, rhs: Vector<N, Bool>) -> Self {
        lhs.masked(by: rhs, fallback: .zero)
    }
}

// MARK: Self.Scalar == Bool
@available(macOS 26.0, *)
public extension Vector where Scalar == Bool {
    /// Maps a vector mask to new values.
    /// - Parameters:
    ///   - lhs: Value when the component is `true`.
    ///   - rhs: Value when the component is `false`.
    ///
    /// - Returns: A new vector with the transformed values.
    func select<T>(true lhs: T, false rhs: T) -> Vector<N, T> {
        map { $0 ? lhs : rhs }
    }
    /// Create a mask for the most relevant index
    /// - Parameter index: Index to be masked.
    /// - Returns: Mask vector where only the component at `index` is marked `true`.
    static func indexMask(_ index: Int) -> Self { .init { $0 == index } }
}

// MARK: Self.Scalar: Comparable
@available(macOS 26.0, *)
public extension Vector where Scalar: Comparable {
    /// Mask for the greater component in a comparison.
    var maxMask: Vector<N, Bool> { .init { $0 == max.scalarIndex } }
    /// Mask for the lesser component in a comparison.
    var minMask: Vector<N, Bool> { .init { $0 == min.scalarIndex } }
}

// MARK: Self.Scalar: ExpressibleByIntegerLiteral
@available(macOS 26.0, *)
public extension Vector where Scalar: ExpressibleByIntegerLiteral {
    /// Vector where all of it's components are 1.
    static var one: Self { .repeating(1) }
    /// Creates a new basis vector.
    /// - Parameters:
    ///   - keyPath: Relevant component of the basis.
    ///   - value: Scalar to be used for the relevant component
    ///
    /// - Returns: A new basis vector with `value` in it's most relevant component and `.zero` everywhere else.
    static func basis(_ keyPath: WritableKeyPath<Self, Scalar>, value: Scalar = 1) -> Self {
        var x = Self.repeating(0)
        x[keyPath: keyPath] = value
        return x
    }
}

// MARK: Self.Scalar: Numeric
@available(macOS 26.0, *)
public extension Vector where Scalar: Numeric {
    /// Vector with 1 in index 0 and zero in the rest.
    static var right: Self { .basis(0, value: 1) }
    /// Vector with -1 in index 0 and zero in the rest.
    static var left: Self { .basis(0, value: -1) }
    /// Vector with 1 in index 1 and zero in the rest.
    static var up: Self { .basis(1, value: 1) }
    /// Vector with -1 in index 1 and zero in the rest.
    static var down: Self { .basis(1, value: -1) }
    /// Vector with 1 in index 2 and zero in the rest.
    static var forward: Self { .basis(2, value: 1) }
    /// Vector with -1 in index 2 and zero in the rest.
    static var back: Self { .basis(2, value: -1) }
    /// Dot product of a vector by itself.
    var magnitudeSquared: Scalar { dot(self) }
    /// Creates a new basis vector.
    /// - Parameter index: Relevant index of the basis.
    /// - Returns: A new basis vector with 1 in it's most relevant index and 0 everywhere else.
    static func basis(_ index: Int) -> Self {
        .basis(index, value: 1, fallback: .zero)
    }
}

// MARK: Self.Scalar: SignedNumeric
@available(macOS 26.0, *)
public extension Vector where Scalar: SignedNumeric, N == 2 {
    /// Perpendicular vector.
    var perpendicular: Self { .init([-y, x]) }
}
