//
//  EmptyBoundary.swift
//  Mathe
//
//  Created by Martônio Júnior on 18/09/2026.
//

/// Boundary that is completely absent of values.
public struct EmptyBoundary<Bound> {
    public init() {}
    // MARK: Methods
    public func difference(_: some Boundary<Bound>) -> Self { self }
    public func intersect(_: some Boundary<Bound>) -> Self { self }
    public func symmetricDifference<B: Boundary>(_ other: B) -> B where B.Bound == Bound { other }
    public func union<B: Boundary>(_ other: B) -> B where B.Bound == Bound { other }
}

// MARK: Self: Boundary
extension EmptyBoundary: Boundary {
    // swiftlint:disable:next missing_docs
    public static func ~= (_: Self, _: Bound) -> Bool { false }
}
