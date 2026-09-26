//
//  Polytope.swift
//  Mathe
//
//  Created by Martônio Júnior on 08/05/2026.
//

public import MatheCoordinates
public import MatheRange
import MatheSIMD

/// Intersection of a set of semi-spaces.
/// 
/// This type works as a generic definition for a shape of any number of dimensions.
/// - N: defines the number of facets that this polytope has.
/// - Facet: structure that defines the space of this polytope.
@available(macOS 26.0.0, *)
public struct Polytope<let n: Int, Facet: Boundary> where Facet.Bound: CoordinateSystem {
    /// List of ordered semi-spaces that bound this polytope.
    /// 
    /// Facets define the space for the polytope.
    var facets: Vector<n, Facet>
}

// MARK: Self: Boundary
extension Polytope: Boundary {
    // swiftlint:disable:next missing_docs
    public typealias Bound = Facet.Bound
    // swiftlint:disable:next missing_docs
    public static func ~= (lhs: Polytope, rhs: Bound) -> Bool {
        lhs.facets.allSatisfy { $0 ~= rhs }
    }
}

// MARK: Self: ExpressibleByArrayLiteral
@available(macOS 26.0.0, *)
extension Polytope: ExpressibleByArrayLiteral {
    // swiftlint:disable:next missing_docs
    public init(arrayLiteral elements: Facet...) {
        self.facets = .init(scalars: elements)
    }
}
