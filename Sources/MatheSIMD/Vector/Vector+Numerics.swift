//
//  Vector+Numerics.swift
//  Mathe
//
//  Created by Martônio Júnior on 23/04/2026.
//

#if Numerics
public import Numerics

// MARK: Self.Scalar: AlgebraicField
@available(macOS 26.0, *)
public extension Vector where Scalar: AlgebraicField {
    /// Vectorial projection of this vector onto another.
    /// - Parameter vector: Vector to be projected to.
    /// - Returns: Vector projected onto `vector`.
    func projected(on vector: Self) -> Self? {
        let n = vector.magnitudeSquared

        guard n != 0 else { return nil }

        return vector * (dot(vector) / n)
    }
    /// Vectorial rejection of this vector onto another.
    /// - Parameter vector: Vector to be projected to.
    /// - Returns: Vector rejection in relation to `vector`.
    func rejected(on vector: Self) -> Self? {
        guard let projectedVector = projected(on: vector) else { return nil }

        return self .- projectedVector
    }
}

@available(macOS 26.0, *)
public extension Vector where Scalar: AlgebraicField & Comparable & ElementaryFunctions {
    /// Returns an equivalent vector where it's magnitude equals one.
    var normalized: Self {
        let m = self.magnitude
        return (m != 0) ? self / m : .repeating(0)
    }
    /// Creates an orthonormalized vector based on a given tangent.
    /// - Parameter tangent: Tangent vector.
    /// - Returns: The delta between the tangent and it's projection on the vector.
    mutating func orthonormalized(by tangent: Self) -> Self {
        self = self.normalized

        guard let p = tangent.projected(on: self) else { return .zero }

        return tangent .- p
    }
    /// Scalar projection of this vector onto another.
    /// 
    /// Also known as an orthogonal projection.
    /// - Parameter vector: Vector to be projected to.
    /// - Returns: Scalar value representing the projection on to `vector`.
    ///   - Positive when the instance is in the same general direction as `vector`.
    ///   - Negative when the instance is pointing in the opposite direction of `vector`.
    ///   - Zero when the instance is perpendicular to `vector`.
    func scalarProjection(on vector: Self) -> Scalar {
        let n = vector.magnitude

        guard n != 0 else { return .zero }

        return dot(vector) / n
    }
    /// Performs a refraction operation in the incident vector.
    /// - Parameters:
    ///   - incident: Incident vector.
    ///   - normal: Normal vector of the surface.
    ///   - n1: Refractive index of the current medium the incident vector is submerged in.
    ///   - n2: Refractive index of the material of the medium the incident vector enters.
    ///
    /// - Returns:
    static func refract(_ incident: Self, normal: Self, n1: Scalar, n2: Scalar) -> Self? {
        let n = n1 / n2
        let cosIncident = -(normal.dot(incident))
        let sinRefractedSquared = n * n * (1 - cosIncident * cosIncident)

        if sinRefractedSquared > 1 { return nil }

        return incident * n .+ normal * (n * cosIncident - .sqrt(1 - sinRefractedSquared))
    }
}

// MARK: Self.Scalar: FloatingPoint
@available(macOS 26.0, *)
public extension Vector where Scalar: Numeric & AlgebraicField {
    /// Reflects a vector based on a surface.
    /// - Parameter normal: Normal vector of the surface.
    /// - Returns: New vector that is reflected from the surface.
    func reflected(normal: Self) -> Self {
        .reflect(self, normal: normal)
    }
    /// Reflects a vector based on a surface.
    /// - Parameters:
    ///   - incident: Incident vector.
    ///   - normal: Normal vector of the surface.
    ///
    /// - Returns: Reflected incident vector.
    static func reflect(_ incident: Self, normal: Self) -> Self {
        incident .- normal * (incident.dot(normal) * 2)
    }
    /// Exterior product of two vectors.
    /// 
    /// Can be used to determine the area occupied by a parallelogram composed of these vectors and their extension.
    /// - Parameters:
    ///   - lhs: A vector.
    ///   - rhs: Another vector.
    ///
    /// - Returns: Value that represents the unsigned determinant of the matrix composed by the two vectors.
    @_disfavoredOverload
    static func ^ (lhs: Self, rhs: Self) -> Scalar where Scalar: ElementaryFunctions {
        Matrix<2, N, Scalar>(.init([lhs, rhs])).unsignedDeterminant
    }
    /// Exterior product of two vectors.
    /// 
    /// Can be used to determine the area occupied by a parallelogram composed of these vectors and their extension.
    /// - Parameters:
    ///   - lhs: A vector.
    ///   - rhs: Another vector.
    ///
    /// - Returns: Value that represents the determinant of the matrix composed by the two vectors.
    static func ^ (lhs: Self, rhs: Self) -> Scalar where Scalar: ElementaryFunctions, N == 2 {
        Matrix<2, N, Scalar>(.init([lhs, rhs])).determinant
    }
}

// MARK: Self.Scalar: Numeric
@available(macOS 26.0, *)
public extension Vector where Scalar: Numeric & Comparable & ElementaryFunctions {
    /// Absolute length for the given type.
    var magnitude: Scalar { Scalar.root(dot(self), 2) }
}
#endif
