//
//  Cell+ByExtent.swift
//  Mathe
//
//  Created by Martônio Júnior on 25/09/2026.
//

public import MatheCoordinates
public import MatheRange
public import MatheSIMD

public extension CellShaped {
    @available(macOS 26.0.0, *)
    struct ByExtent<let n: Int, Scalar: AdditiveArithmetic> {
        // MARK: Variables
        var extents: Vector<n, Scalar>
    }
}

@available(macOS 26.0.0, *)
public extension CellShaped.ByExtent {
    var bounds: Vector<n, Extent<Scalar>> {
        min.pointwise(max, as: Vector<n, Extent<Scalar>>.self) {
            Extent(from: $0, to: $1)
        }
    }

    /// Center for each face in the box
    var faceCenters: [CartesianCoordinate<n, Scalar>] {
        (0..<n).reduce(into: .init()) {
            $0.append(.cartesian(.basis($1, value: min[$1])))
            $0.append(.cartesian(.basis($1, value: max[$1])))
        }
    }

    var min: CartesianCoordinate<n, Scalar> { .cartesian(.zero - extents) }
    var max: CartesianCoordinate<n, Scalar> { .cartesian(extents) }
    var size: Vector<n, Scalar> { extents + extents }

    // MARK: Initializers
    init(_ extents: Vector<n, Scalar>) {
        self.extents = extents
    }

    // MARK: Methods
    /// Expands the box by a certain amount on all sides
    func expanded(extentsBy amount: Vector<n, Scalar>) -> Self {
        .init(extents: extents .+ amount)
    }
}

// MARK: Conversions
@available(macOS 26.0.0, *)
public extension CellShaped.ByExtent {
    var byMinMax: CellShaped.MinMax<n, Scalar> {
        .init(min: min, max: max)
    }
}

// MARK: Self: Boundary
@available(macOS 26.0.0, *)
extension CellShaped.ByExtent: Boundary where Scalar: Comparable {
    public typealias Bound = Coordinate

    public static func ~= (lhs: Self, rhs: Coordinate) -> Bool {
        rhs.pointwise(lhs.max, as: Vector<n, Bool>.self, merge: <=).all
        && rhs.pointwise(lhs.min, as: Vector<n, Bool>.self, merge: >=).all
    }
}

// MARK: Self: Ceiling
@available(macOS 26.0.0, *)
extension CellShaped.ByExtent: Ceiling where Scalar: AdditiveArithmetic {
    public var upperBound: CartesianCoordinate<n, Scalar> { max }
}

// MARK: Self: Equatable
@available(macOS 26.0.0, *)
extension CellShaped.ByExtent: Equatable where Scalar: Equatable {}

// MARK: Self: Floor
@available(macOS 26.0.0, *)
extension CellShaped.ByExtent: Floor where Scalar: AdditiveArithmetic {
    public var lowerBound: CartesianCoordinate<n, Scalar> { min }
}

// MARK: Self: Geometric
@available(macOS 26.0.0, *)
extension CellShaped.ByExtent: Geometric {
    // swiftlint:disable:next missing_docs
    public typealias Coordinate = CartesianCoordinate<n, Scalar>
}

// MARK: Self: Polygon
@available(macOS 26.0.0, *)
extension CellShaped.ByExtent: Polygon {
    // swiftlint:disable:next missing_docs
    public var edges: [Extent<Coordinate>] {
        fatalError("Not implemented yet.")
    }
    // swiftlint:disable:next missing_docs
    public var vertices: [Coordinate] {
        let pairs = min.pointwise(max, as: Vector<n, Vector<2, Scalar>>.self) { .init([$0, $1]) }
        var result: [[Scalar]] = [[.zero]]

        for pair in pairs {
            result = result.flatMap { v in
                pair.map { v + [$0] }
            }
        }

        return result.map {
            .cartesian(.init(scalars: [Scalar]($0.dropFirst())))
        }
    }
}

// MARK: Self: Shape
@available(macOS 26.0.0, *)
extension CellShaped.ByExtent: Shape where Scalar: Comparable {
    // swiftlint:disable:next missing_docs
    public func isOutline(for point: Coordinate) -> Bool {
        point.pointwise(max, as: Vector<n, Bool>.self, merge: ==).any
        || point.pointwise(min, as: Vector<n, Bool>.self, merge: ==).any
    }
}

// MARK: Self.Scalar: Comparable
@available(macOS 26.0.0, *)
extension CellShaped.ByExtent where Scalar: Comparable {
    func canSubdivide(withSlicesOf minimumSlice: Scalar) -> Bool where Scalar: Comparable {
        size.allSatisfy { $0 > minimumSlice }
    }

    func closestPoint(basedOn point: CartesianCoordinate<n, Scalar>) -> CartesianCoordinate<n, Scalar> {
        point.pointwise(bounds) { $1.clamp($0) }
    }
}

// MARK: Self.Scalar: SignedNumeric
@available(macOS 26.0.0, *)
public extension CellShaped.ByExtent where Scalar: SignedNumeric & Comparable {
    func squareDistance(to point: CartesianCoordinate<n, Scalar>) -> Scalar {
        point.pointwise(bounds) { $1.clamp($0) }.magnitudeSquared
    }
}

// MARK: Intersection (EX)
@available(macOS 26.0.0, *)
public extension Intersection where A == B {
    func cellsOverlap<let n: Int, T: AdditiveArithmetic & Comparable>() -> Bool
    where A == Placed<CellShaped.ByExtent<n, T>, CartesianCoordinate<n, T>> {
        left.min().pointwise(right.max(), as: Vector<n, Bool>.self, merge: <=).all
        && left.max().pointwise(right.min(), as: Vector<n, Bool>.self, merge: >=).all
    }
}

// MARK: Placed (EX)
@available(macOS 26.0.0, *)
public extension Placed {
    func closestPoint<let n: Int, T: AdditiveArithmetic & Comparable>(
        basedOn point: CartesianCoordinate<n, T>
    ) -> CartesianCoordinate<n, T>
    where Element == CellShaped.ByExtent<n, Coordinate.Scalar>, Coordinate == CartesianCoordinate<n, T> {
        position .+ element.closestPoint(basedOn: point .- position)
    }

    func faceCenters<let n: Int, T: AdditiveArithmetic>() -> [CartesianCoordinate<n, T>]
    where Element == CellShaped.ByExtent<n, Coordinate.Scalar>, Coordinate == CartesianCoordinate<n, T> {
        element.faceCenters.map { position .+ $0 }
    }

    func min<let n: Int, T: AdditiveArithmetic>() -> CartesianCoordinate<n, T>
    where Element == CellShaped.ByExtent<n, Coordinate.Scalar>, Coordinate == CartesianCoordinate<n, T> {
        position.pointwise(element.extents, merge: -)
    }

    func max<let n: Int, T: AdditiveArithmetic>() -> CartesianCoordinate<n, T>
    where Element == CellShaped.ByExtent<n, Coordinate.Scalar>, Coordinate == CartesianCoordinate<n, T> {
        position .+ element.max
    }

    func squareDistance<let n: Int, T: SignedNumeric & Comparable>(
        to point: CartesianCoordinate<n, T>
    ) -> T where Element == CellShaped.ByExtent<n, Coordinate.Scalar>, Coordinate == CartesianCoordinate<n, T> {
        element.squareDistance(to: point .- position)
    }
}

// MARK: Numerics (Trait)
#if Numerics
public import Numerics

@available(macOS 26.0.0, *)
public extension CellShaped.ByExtent where Scalar: AlgebraicField {
    func relativeDistance(of point: CartesianCoordinate<n, Scalar>) -> Vector<n, Scalar> {
        point.components ./ size
    }

    mutating func resize(to newSize: Vector<n, Scalar>) {
        extents = newSize / 2
    }
}

@available(macOS 26.0.0, *)
public extension CellShaped.ByExtent where Scalar: AlgebraicField & Comparable {
    func encapsulating(point: CartesianCoordinate<n, Scalar>) -> Self {
        .init(extents: point.pointwise(abs).pointwise(extents, as: Vector<n, Scalar>.self, merge: Swift.max))
    }

    func encapsulating(bounds: Self) -> Self {
        encapsulating(point: bounds.max)
    }
}

@available(macOS 26.0.0, *)
public extension Placed {
    init<let n: Int, T: AlgebraicField>(
        _ center: CartesianCoordinate<n, T>,
        size: Vector<n, T>
    ) where Element == CellShaped.ByExtent<n, Coordinate.Scalar>, Coordinate == CartesianCoordinate<n, T> {
        self.init(.init(extents: size / 2), in: center)
    }

    func encapsulating<let n: Int, T: AlgebraicField & Comparable>(
        point: CartesianCoordinate<n, T>
    ) -> Self where Element == CellShaped.ByExtent<n, Coordinate.Scalar>, Coordinate == CartesianCoordinate<n, T> {
        .init(element.encapsulating(point: point .- position), in: position)
    }

    func encapsulating<let n: Int, T: AlgebraicField & Comparable>(
        bounds: Self
    ) -> Self where Element == CellShaped.ByExtent<n, Coordinate.Scalar>, Coordinate == CartesianCoordinate<n, T> {
        encapsulating(point: bounds.min()).encapsulating(point: bounds.max())
    }

    func relativeDistance<let n: Int, T: AlgebraicField>(
        to point: CartesianCoordinate<n, T>
    ) -> Vector<n, T> where Element == CellShaped.ByExtent<n, Coordinate.Scalar>, Coordinate == CartesianCoordinate<n, T> {
        element.relativeDistance(of: point .- position)
    }

    func subBox<let n: Int, T: AlgebraicField & Comparable>(
        for point: CartesianCoordinate<n, T>
    ) -> Self where Element == CellShaped.ByExtent<n, Coordinate.Scalar>, Coordinate == CartesianCoordinate<n, T> {
        let offset = element.extents .* signVector(for: point) / 2
        let shape = Element(extents: element.extents / 2)
        return .init(shape, in: position.offset(by: offset))
    }

    func signVector<let n: Int, T: AlgebraicField & Comparable>(
        for point: CartesianCoordinate<n, T>
    ) -> Vector<n, T> where Element == CellShaped.ByExtent<n, Coordinate.Scalar>, Coordinate == CartesianCoordinate<n, T> {
        point.pointwise(position, as: Vector<n, T>.self) { $0 >= $1 ? 1 : -1 }
    }
}

@available(macOS 26.0.0, *)
extension CellShaped.ByExtent: Gamut where Scalar: AlgebraicField {
    // swiftlint:disable:next missing_docs
    public init(from lowerBound: Coordinate, to upperBound: Coordinate) {
        self.init((upperBound.components .- lowerBound.components) / 2)
    }
}

#endif
