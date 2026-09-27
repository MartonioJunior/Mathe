//
//  Polytope.swift
//  Mathe
//
//  Created by Martônio Júnior on 08/05/2026.
//

#if Numerics
public import MatheCoordinates
public import MatheRange
import MatheSIMD
public import Numerics

/// Intersection of a set of semi-spaces.
/// 
/// This type works as a generic definition for a shape of any number of dimensions.
/// - n: Dimension of the polytope.
/// - count: Number of planes required to make a shape.
/// - Facet: structure that defines the space of this polytope.
@available(macOS 26.0.0, *)
public struct Polytope<let n: Int, let count: Int, Scalar: AlgebraicField & Comparable & ElementaryFunctions> {
    /// List of ordered semi-spaces that bound this polytope.
    /// 
    /// Facets define the space for the polytope.
    var features: Vector<count, Plane<n, Scalar>>
}

// MARK: Self: Boundary
@available(macOS 26.0.0, *)
extension Polytope: Boundary {
    // swiftlint:disable:next missing_docs
    public typealias Bound = CartesianCoordinate<n, Scalar>
    // swiftlint:disable:next missing_docs
    public static func ~= (lhs: Self, rhs: Bound) -> Bool {
        lhs.features.allSatisfy { $0.height(for: rhs) <= .zero }
    }
}

// MARK: Self: ExpressibleByArrayLiteral
@available(macOS 26.0.0, *)
extension Polytope: ExpressibleByArrayLiteral {
    // swiftlint:disable:next missing_docs
    public init(arrayLiteral elements: Plane<n, Scalar>...) {
        self.features = .init(scalars: elements)
    }
}
#endif
