//
//  Swizzleable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/09/2025.
//

/// Protocol that defines a type that can have it's features extracted into a fixed list of values.
public protocol Swizzleable {}

// MARK: Default Implementation
@available(macOS 26.0, *)
public extension Swizzleable {
    /// Creates a new list of values based on the elements extracted from the type.
    /// - Parameter swizzle: Functions that extract the desired value for each array element.
    /// - Returns: An `InlineArray` containing all extracted elements from the type.
    subscript<let A: Int, T>(_ swizzle: [A of (Self) -> T]) -> [A of T] {
        extract(self, features: swizzle)
    }
}

// MARK: Global
/// Performs an extraction of a type's features, returning a swizzled array.
/// - Parameters:
///   - element: Element to be extracted.
///   - features: List of functions extracted.
///
/// - Returns: A new `InlineArray` with the extracted elements.
@available(macOS 26.0, *)
public func extract<Element, let A: Int, T>(_ element: Element, features: [A of (Element) -> T]) -> [A of T] {
    features.map { $0(element) }
}

// MARK: Sequence (EX)
@available(macOS 26.0, *)
public extension Sequence {
    /// Creates a new list of values based on the elements extracted from the sequence.
    /// - Parameter swizzle: Functions that extract the desired value for each array element.
    /// - Returns: An `InlineArray` containing all extracted elements from the sequence.
    @_disfavoredOverload
    subscript<let A: Int>(_ swizzle: [A of (Self) -> Element]) -> [A of Element] {
        extract(self, features: swizzle)
    }
}

@available(macOS 26.0, *)
public extension SIMD {
    /// Creates a new SIMD of values based on the elements extracted from the SIMD.
    /// - Parameter swizzle: Functions that extract the desired value for each array element.
    /// - Returns: A new instance of itself containing all extracted elements from the SIMD.
    subscript<let A: Int>(_ swizzle: [A of (Self) -> Scalar]) -> Self {
        .init(extract(self, features: swizzle).flexible)
    }
}

@available(macOS 26.0, *)
public extension InlineArray {
    /// Creates a new list of values based on the elements extracted from the array.
    /// - Parameter swizzle: Functions that extract the desired value for each array element.
    /// - Returns: An `InlineArray` containing all extracted elements from the array.
    subscript<let A: Int>(_ swizzle: [A of (Self) -> Element]) -> [A of Element] {
        extract(self, features: swizzle)
    }
}
