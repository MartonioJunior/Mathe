//
//  Extent.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/04/2026.
//

public struct Extent<Bound> {
    // MARK: Variables
    public var lowerBound: Bound
    public var upperBound: Bound
    var boundPredicate: (Bound) -> Bool

    // MARK: Initializers
    public init(
        from lowerBound: Bound,
        to upperBound: Bound,
        boundPredicate: @escaping (Bound) -> Bool
    ) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.boundPredicate = boundPredicate
    }
}

// MARK: Self: Gamut
extension Extent: Gamut {
    public init(from lowerBound: Bound, to upperBound: Bound) {
        self.init(from: lowerBound, to: upperBound) { _ in false }
    }

    public static func ~= (lhs: Extent<Bound>, rhs: Bound) -> Bool {
        lhs.boundPredicate(rhs)
    }
}
