//
//  AABB.swift
//  Mathe
//
//  Created by Martônio Júnior on 05/05/2026.
//

public import MatheCoordinates
public import MatheRange
public import MatheSIMD

// MARK: Aliases
@available(macOS 26.0.0, *)
public typealias AABB = AxisAlignedBoundingBox
/// Two-dimensional AABB
@available(macOS 26.0.0, *)
public typealias Rect<Scalar: AdditiveArithmetic> = AABB<2, Scalar>
/// Three-dimensional AABB
@available(macOS 26.0.0, *)
public typealias Box<Scalar: AdditiveArithmetic> = AABB<3, Scalar>

@available(macOS 26.0.0, *)
public struct AxisAlignedBoundingBox<let n: Int, Scalar: AdditiveArithmetic> {
    public typealias Bound = CartesianCoordinate<n, Scalar>

    // MARK: Variables
    public var center: CartesianCoordinate<n, Scalar>
    public var extents: Vector<n, Scalar>

    // MARK: Initializers
    public init(_ center: CartesianCoordinate<n, Scalar>, extents: Vector<n, Scalar>) {
        self.center = center
        self.extents = extents
    }
}

// MARK: Self: Boundary
@available(macOS 26.0.0, *)
extension AxisAlignedBoundingBox: Boundary where Scalar: Comparable {
    public static func ~= (lhs: Self, rhs: Bound) -> Bool {
        rhs.pointwise(lhs.max, as: Vector<n, Bool>.self, merge: <=).all
        && rhs.pointwise(lhs.min, as: Vector<n, Bool>.self, merge: >=).all
    }
}

// MARK: Self: Equatable
@available(macOS 26.0.0, *)
extension AxisAlignedBoundingBox: Equatable where Scalar: Equatable {}

// MARK: Self: Floor
@available(macOS 26.0.0, *)
extension AxisAlignedBoundingBox: Floor where Scalar: AdditiveArithmetic {
    public var lowerBound: Bound { min }
}

// MARK: Self: Ceiling
@available(macOS 26.0.0, *)
extension AxisAlignedBoundingBox: Ceiling where Scalar: AdditiveArithmetic {
    public var upperBound: Bound { max }
}

// MARK: Self.Scalar: AdditiveArithmetic
@available(macOS 26.0.0, *)
extension AxisAlignedBoundingBox where Scalar: AdditiveArithmetic {
    var min: CartesianCoordinate<n, Scalar> { .cartesian(center.components .- extents) }
    var max: CartesianCoordinate<n, Scalar> { .cartesian(center.components .+ extents) }
    /// Vertices for each type
    var corners: [CartesianCoordinate<n, Scalar>] {
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
    /// Center for each face in the box
    var faceCenters: [CartesianCoordinate<n, Scalar>] {
        (0..<n).reduce(into: .init()) {
            $0.append(.cartesian(.basis($1, value: min[$1])))
            $0.append(.cartesian(.basis($1, value: max[$1])))
        }
    }
    /// Expands the box by a certain amount on all sides
    func expanded(extentsBy amount: Vector<n, Scalar>) -> Self {
        .init(center, extents: extents .+ amount)
    }
}

// MARK: Self.Scalar: Numeric
@available(macOS 26.0.0, *)
public extension AxisAlignedBoundingBox where Scalar: Numeric {
    var size: Vector<n, Scalar> { extents * 2 }

    func canSubdivide(withSlicesOf minimumSlice: Scalar) -> Bool where Scalar: Comparable {
        size.allSatisfy { $0 > minimumSlice }
    }
}

@available(macOS 26.0.0, *)
public extension AxisAlignedBoundingBox where Scalar: Numeric & Comparable {
    func intersects(withBounds bounds: Self) -> Bool {
        min.pointwise(bounds.max, as: Vector<n, Bool>.self, merge: <=).all
        && max.pointwise(bounds.min, as: Vector<n, Bool>.self, merge: >=).all
    }
}

// MARK: Self.Scalar: SignedNumeric
@available(macOS 26.0.0, *)
public extension AxisAlignedBoundingBox where Scalar: SignedNumeric & Comparable {
    func closestPoint(basedOn point: CartesianCoordinate<n, Scalar>) -> CartesianCoordinate<n, Scalar> {
        center .+ (point .- center).pointwise(extents) { (-$1...$1).clamp($0) }
    }

    func squareDistance(to point: CartesianCoordinate<n, Scalar>) -> Scalar {
        (point .- center).pointwise(extents) { (-$1...$1).clamp($0) }.components.magnitudeSquared
    }
}

// MARK: Numerics (Trait)
#if Numerics
public import Numerics

@available(macOS 26.0.0, *)
public extension AxisAlignedBoundingBox where Scalar: AlgebraicField {
    init(_ center: CartesianCoordinate<n, Scalar>, size: Vector<n, Scalar>) {
        self.init(center, extents: size / 2)
    }

    init(min: CartesianCoordinate<n, Scalar>, max: CartesianCoordinate<n, Scalar>) {
        let extents = (max.components .- min.components) / 2
        self.init(min.pointwise(extents, merge: +), extents: extents)
    }

    mutating func resize(to newSize: Vector<n, Scalar>) {
        extents = newSize / 2
    }

    func relativeDistance(of point: CartesianCoordinate<n, Scalar>) -> Vector<n, Scalar> {
        (point .- center).components ./ size
    }

    mutating func updateSize(_ newSize: Vector<n, Scalar>) {
        extents = newSize / 2
    }
}

@available(macOS 26.0.0, *)
public extension AxisAlignedBoundingBox where Scalar: AlgebraicField & Comparable {
    func encapsulating(point: CartesianCoordinate<n, Scalar>) -> Self {
        .init(
            min: .cartesian(min.pointwise(point, as: Vector<n, Scalar>.self, merge: Swift.min)),
            max: .cartesian(max.pointwise(point, as: Vector<n, Scalar>.self, merge: Swift.max))
        )
    }

    func encapsulating(bounds: Self) -> Self {
        encapsulating(point: bounds.min).encapsulating(point: bounds.max)
    }

    func subBox(for point: CartesianCoordinate<n, Scalar>) -> Self {
        let offset = extents .* signVector(for: point) / 2
        return .init(.cartesian(center.components .+ offset), size: extents)
    }

    func signVector(for point: CartesianCoordinate<n, Scalar>) -> Vector<n, Scalar> {
        point.pointwise(center, as: Vector<n, Scalar>.self) { $0 >= $1 ? 1 : -1 }
    }
}

@available(macOS 26.0.0, *)
extension AxisAlignedBoundingBox: Gamut where Scalar: AlgebraicField {
    public init(from lowerBound: Bound, to upperBound: Bound) {
        self.init(min: lowerBound, max: upperBound)
    }
}
#endif
