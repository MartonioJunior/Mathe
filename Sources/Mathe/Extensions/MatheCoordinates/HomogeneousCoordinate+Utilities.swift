//
//  HomogeneousCoordinate+Numerics.swift
//  Mathe
//
//  Created by Martônio Júnior on 21/09/2026.
//

#if Numerics
public import MatheSIMD
public import Numerics

// MARK: Self.Scalar: ElementaryFunctions
public extension HomogeneousCoordinate where Base: Pointwise, Scalar: ElementaryFunctions & Numeric {
    @available(macOS 26.0, *)
    static func from<let n: Int, T: Real>(_ v1: Vector<n, T>, to v2: Vector<n, T>) -> Self where Base == CartesianCoordinate<n, T> {
        .init(.cartesian(.repeating(v1.cross(v2))), w: .sqrt(v1.magnitudeSquared * v2.magnitudeSquared) + v1.dot(v2))
    }
}

// MARK: Self.Scalar: Real
@available(macOS 26.0.0, *)
public extension HomogeneousCoordinate where Scalar: Real {
    func rotationMatrix<let n: Int, T>() -> Matrix<n, n, T> where Base == CartesianCoordinate<n, T> {
        .init(.init { .rotation(basis: $0, rotatedBy: base[$0]) })
    }
}

public extension HomogeneousCoordinate where Base: Pointwise, Scalar: Real {
    func angle(to other: Self) -> Scalar {
        let d = components.dot(other.components)
        return .acos((d * d * 2 - 1).normalized)
    }
}
#endif
