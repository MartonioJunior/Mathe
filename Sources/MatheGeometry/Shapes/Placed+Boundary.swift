//
//  Placed+Boundary.swift
//  Mathe
//
//  Created by Martônio Júnior on 25/09/2026.
//

public import MatheRange
public import MatheSIMD

extension Placed: Boundary where Element: Boundary, Coordinate: Pointwise,
Element.Bound == Coordinate, Coordinate.Scalar: AdditiveArithmetic {
    // swiftlint:disable:next missing_docs
    public typealias Bound = Element.Bound
    // swiftlint:disable:next missing_docs
    public static func ~= (lhs: Self, rhs: Coordinate) -> Bool {
        lhs.element ~= (rhs .+ lhs.position)
    }
}
