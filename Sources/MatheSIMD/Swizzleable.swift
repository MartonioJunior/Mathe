//
//  Swizzleable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/09/2025.
//

/// Protocol that defines a type that can have it's features extracted into a InlineArray
public protocol Swizzleable {}

// MARK: Default Implementation
@available(macOS 26.0, *)
public extension Swizzleable {
    subscript<let A: Int, T>(_ swizzle: [A of (Self) -> T]) -> [A of T] {
        extract(self, features: swizzle)
    }
}

// MARK: Global
/// Performs an extraction of a type's features, returning a swizzled array
@available(macOS 26.0, *)
public func extract<Element, let A: Int, T>(_ element: Element, features: [A of (Element) -> T]) -> [A of T] {
    features.map { $0(element) }
}

// MARK: Sequence (EX)
@available(macOS 26.0, *)
public extension Sequence {
    @_disfavoredOverload
    subscript<let A: Int>(_ swizzle: [A of (Self) -> Element]) -> [A of Element] {
        extract(self, features: swizzle)
    }
}

@available(macOS 26.0, *)
public extension SIMD {
    subscript<let A: Int>(_ swizzle: [A of (Self) -> Scalar]) -> Self {
        .init(extract(self, features: swizzle).flexible)
    }
}

@available(macOS 26.0, *)
public extension InlineArray {
    subscript<let A: Int>(_ swizzle: [A of (Self) -> Element]) -> InlineArray<A, Element> {
        extract(self, features: swizzle)
    }
}
