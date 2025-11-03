//
//  InlineArray+Trinkets.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/09/2025.
//

@available(macOS 26.0, *)
internal extension InlineArray {
    var flexible: [Element] { indices.map { self[$0] } }

    func forEach(_ action: (Element) throws -> Void) rethrows {
        for i in indices {
            try action(self[i])
        }
    }

    func map<T>(_ transform: (Element) throws -> T) rethrows -> [count of T] {
        try .init { try transform(self[$0]) }
    }
}

// MARK: Self: Equatable
@available(macOS 26.0, *)
extension InlineArray: @retroactive Equatable where Element: Equatable {
    public static func == (lhs: InlineArray<count, Element>, rhs: InlineArray<count, Element>) -> Bool {
        for i in lhs.indices where lhs[i] != rhs[i] {
            return false
        }

        return true
    }
}
