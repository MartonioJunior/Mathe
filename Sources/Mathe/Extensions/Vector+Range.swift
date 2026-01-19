//
//  Vector+Range.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/12/2025.
//

public import MatheRange
public import MatheSIMD

@available(macOS 26.0, *)
public typealias Quad<B: Boundary> = Vector<2, B>
@available(macOS 26.0, *)
public typealias Box<B: Boundary> = Vector<3, B>

// MARK: Self: Boundary
@available(macOS 26.0, *)
extension Vector: Boundary where Scalar: Boundary {
    public typealias Bound = Vector<N, Scalar.Bound>

    public static func ~= (lhs: Self, rhs: Bound) -> Bool {
        lhs.indices.allSatisfy { lhs[$0] ~= rhs[$0] }
    }
}

// MARK: Self: Ceiling
@available(macOS 26.0, *)
extension Vector: Ceiling where Scalar: Ceiling {
    public var upperBound: Vector<N, Scalar.Bound> { map(\.upperBound) }
}

// MARK: Self: Floor
@available(macOS 26.0, *)
extension Vector: Floor where Scalar: Floor {
    public var lowerBound: Vector<N, Scalar.Bound> { map(\.lowerBound) }
}

// MARK: Self: Gamut
@available(macOS 26.0, *)
extension Vector: Gamut where Scalar: Gamut {
    public init(from lowerBound: Vector<N, Scalar.Bound>, to upperBound: Vector<N, Scalar.Bound>) {
        self.init(scalars: zip(lowerBound, upperBound).map { Scalar(from: $0, to: $1) })
    }

    public func canSubdivide(
        withSlicesOf minimumSlice: Scalar.Bound
    ) -> Bool where Scalar.Bound: AdditiveArithmetic & Comparable {
        allSatisfy { $0.distance > minimumSlice }
    }

    public func directionFlags(
        for point: Vector<N, Scalar.Bound>
    ) -> Vector<N, Bool> where Scalar.Bound: AdditiveArithmetic & Comparable {
        let sum = map(\.sum)
        return .init { sum[$0] >= point[$0] }
    }

    public func subregion(
        for point: Vector<N, Scalar.Bound>
    ) -> Self where Scalar.Bound == Double {
        let sum = map(\.sum)
        let half = 0.5
        let multipliersFrom: Vector<N, Scalar.Bound> = .init { sum[$0] >= point[$0] ? half : 0 }
        let multipliersTo: Vector<N, Scalar.Bound> = .init { multipliersFrom[$0] + half }
        return Vector(from: lowerBound + multipliersFrom * sum, to: lowerBound + multipliersTo * sum)
    }
}
