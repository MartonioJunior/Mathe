//
//  UniverseBoundary.swift
//  Mathe
//
//  Created by Martônio Júnior on 18/09/2026.
//

/// Boundary that represents all possible values for a type.
public struct UniverseBoundary<Bound> {
    // MARK: Methods
    public func difference(_: some Boundary<Bound>) -> EmptyBoundary<Bound> { .init() }
    public func intersect<B: Boundary>(_ other: B) -> B where B.Bound == Bound { other }
    public func symmetricDifference(_: some Boundary<Bound>) -> EmptyBoundary<Bound> { .init() }
    public func union(_: some Boundary<Bound>) -> Self { self }
}

// MARK: Self: Boundary
extension UniverseBoundary: Boundary {
    // swiftlint:disable:next missing_docs
    public static func ~= (_: Self, _: Bound) -> Bool { true }
}
