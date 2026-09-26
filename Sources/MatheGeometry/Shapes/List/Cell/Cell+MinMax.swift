//
//  Cell+MinMax.swift
//  Mathe
//
//  Created by Martônio Júnior on 25/09/2026.
//

public import MatheCoordinates
public import MatheSIMD

// MARK: Self.MinMax
public extension CellShaped {
    @available(macOS 26.0.0, *)
    struct MinMax<let n: Int, Scalar: AdditiveArithmetic> {
        var min: CartesianCoordinate<n, Scalar>
        var max: CartesianCoordinate<n, Scalar>

        public init(min: CartesianCoordinate<n, Scalar>, max: CartesianCoordinate<n, Scalar>) {
            self.min = min
            self.max = max
        }
    }
}

// MARK: Self: Geometric
@available(macOS 26.0.0, *)
extension CellShaped.MinMax: Geometric {
    public typealias Coordinate = CartesianCoordinate<n, Scalar>
}

// MARK: Self: Shape
@available(macOS 26.0.0, *)
extension CellShaped.MinMax: Shape where Scalar: SignedNumeric & Comparable {
    public func isOutline(for point: Coordinate) -> Bool {
        point.pointwise(min, as: Vector<n, Bool>.self, merge: <=).all
        && point.pointwise(max, as: Vector<n, Bool>.self, merge: >=).all
    }
}

// MARK: Numerics (Trait)
#if Numerics
public import Numerics

@available(macOS 26.0.0, *)
public extension CellShaped.MinMax where Scalar: AlgebraicField {
    var byExtent: CellShaped.ByExtent<n, Scalar> {
        .init(from: min, to: max)
    }
}

@available(macOS 26.0.0, *)
public extension CellShaped.MinMax where Scalar: AlgebraicField & Comparable {
    func encapsulating(point: CartesianCoordinate<n, Scalar>) -> Self {
        .init(
            min: .cartesian(min.pointwise(point, as: Vector<n, Scalar>.self, merge: Swift.min)),
            max: .cartesian(max.pointwise(point, as: Vector<n, Scalar>.self, merge: Swift.max))
        )
    }
}
#endif
