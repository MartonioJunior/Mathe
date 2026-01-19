//
//  CoordinateSystem+SIMD.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

public import MatheCoordinates
public import MatheSIMD

// MARK: Barycentric Coordinate
public extension CoordinateSystem {
    @available(macOS 26.0, *)
    static func barycentric<let N: Int, Scalar: FloatingPoint>(
        _ value: Vector<N, Scalar>,
        inRelationTo bounds: Vector<N, Scalar>
    ) -> Self where Self == BarycentricCoordinate<Vector<N, Scalar>> {
        .relative(value ./ bounds)
    }
}

// MARK: Cartesian Coordinate
public extension CoordinateSystem where Self == CartesianCoordinate {
    @available(macOS 26.0, *)
    static func cartesian(_ vector: Vector2) -> Self {
        .cartesian(x: vector[0], y: vector[1])
    }
}

// MARK: Cylindrical Coordinate
public extension CoordinateSystem where Self == CylindricalCoordinate {
    @available(macOS 26.0, *)
    static func cylindrical(_ vector: Vector3) -> Self {
        .cylindrical(r: vector[0], angle: vector[1], h: vector[2])
    }
}

// MARK: Geographic Coordinate
public extension CoordinateSystem where Self == GeographicCoordinate {
    @available(macOS 26.0, *)
    static func geographic(_ vector: Vector2) -> Self {
        .geographic(lat: vector[0], lng: vector[1])
    }
}

// MARK: Homogeneous Coordinate
@available(macOS 26.0, *)
public typealias Quaternion<let N: Int> = HomogeneousCoordinate<Vector<N, Double>>

public extension CoordinateSystem {
    @available(macOS 26.0, *)
    static func homogeneous(_ vector: Vector4) -> Self where Self == HomogeneousCoordinate<Vector3> {
        .homogeneous([vector[0], vector[1], vector[2]], w: vector[3])
    }
}

// MARK: Polar Coordinate
public extension CoordinateSystem where Self == PolarCoordinate {
    @available(macOS 26.0, *)
    static func polar(_ vector: Vector2) -> Self {
        .polar(r: vector[0], a: vector[1])
    }
}

// MARK: Spherical Coordinate
public extension CoordinateSystem where Self == SphericalCoordinate {
    @available(macOS 26.0, *)
    static func spherical(_ vector: Vector3) -> Self {
        .spherical(r: vector[0], theta: vector[1], phi: vector[2])
    }
}

// MARK: Vector (EX)
@available(macOS 26.0, *)
extension Vector: CoordinateSystem {
    public var components: [Scalar] { map(\.self) }
}
