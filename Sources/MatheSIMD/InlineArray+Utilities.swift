//
//  InlineArray+Trinkets.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/09/2025.
//

@available(macOS 26.0, *)
internal extension InlineArray {
    /// Creates a flexible array of elements.
    var flexible: [Element] { indices.map { self[$0] } }
    /// Iterates through all elements of an inline array.
    /// - Parameter action: Closure executed for each element.
    /// - Throws: Error `E` when an action encounters a problem.
    func forEach<E: Error>(_ action: (Element) throws(E) -> Void) rethrows {
        for i in indices {
            try action(self[i])
        }
    }
    /// Maps each element of the inline array.
    /// - Parameter transform: Transformation function.
    /// - Throws: Error `E` when the transformation encounters a problem.
    /// - Returns: A new `InlineArray` with the transformed elements.
    func map<T, E: Error>(_ transform: (Element) throws(E) -> T) rethrows -> [count of T] {
        try .init { try transform(self[$0]) }
    }
}

// MARK: Self: Equatable
@available(macOS 26.0, *)
extension InlineArray: @retroactive Equatable where Element: Equatable {
    // swiftlint:disable:next missing_docs
    public static func == (lhs: InlineArray<count, Element>, rhs: InlineArray<count, Element>) -> Bool {
        for i in lhs.indices where lhs[i] != rhs[i] {
            return false
        }

        return true
    }
}
