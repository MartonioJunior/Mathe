//
//  Vector+Dimensions.swift
//  Mathe
//
//  Created by Martônio Júnior on 11/05/2026.
//

// MARK: Self.N == 1
@available(macOS 26.0, *)
public extension Vector where N == 1 {
    /// Component of the vector in the X axis.
    var x: Scalar {
        get { elements[0] }
        set { elements[0] = newValue }
    }
}

// MARK: Self.N == 2
#if VectorAliases
/// Two-dimensional vector.
@available(macOS 26.0, *)
public typealias Vector2 = Vector<2, Double>
/// Two-dimensional integer vector.
@available(macOS 26.0, *)
public typealias Vector2Int = Vector<2, Int>
#endif

@available(macOS 26.0, *)
public extension Vector where N == 2 {
    /// Component of the vector in the X axis.
    var x: Scalar {
        get { elements[0] }
        set { elements[0] = newValue }
    }
    /// Component of the vector in the Y axis.
    var y: Scalar {
        get { elements[1] }
        set { elements[1] = newValue }
    }
    /// Cross product of the vector against another.
    /// - Parameter rhs: Another vector.
    /// - Returns: Determinant of the 2x2 matrix created by the two vectors.
    func cross(_ rhs: Self) -> Scalar where Scalar: Numeric {
        x * rhs.y - y * rhs.x
    }
}

// MARK: Self.N == 3
#if VectorAliases
/// Three-dimensional vector.
@available(macOS 26.0, *)
public typealias Vector3 = Vector<3, Double>
/// Three-dimensional integer vector.
@available(macOS 26.0, *)
public typealias Vector3Int = Vector<3, Int>
#endif

@available(macOS 26.0, *)
public extension Vector where N == 3 {
    /// Component of the vector in the X axis.
    var x: Scalar {
        get { elements[0] }
        set { elements[0] = newValue }
    }
    /// Component of the vector in the Y axis.
    var y: Scalar {
        get { elements[1] }
        set { elements[1] = newValue }
    }
    /// Component of the vector in the Z axis.
    var z: Scalar {
        get { elements[2] }
        set { elements[2] = newValue }
    }
    /// Cross product of the vector against another.
    /// - Parameter rhs: Another vector.
    /// - Returns: Vector where each component projects the determinant of a 2x2 matrix the other dimensions.
    func cross(_ rhs: Self) -> Self where Scalar: Numeric {
        .init([
            y * rhs.z - z * rhs.y,
            z * rhs.x - x * rhs.z,
            x * rhs.y - y * rhs.x
        ])
    }
}

// MARK: Self.N == 4
#if VectorAliases
/// Four-dimensional vector.
@available(macOS 26.0, *)
public typealias Vector4 = Vector<4, Double>
/// Four-dimensional integer vector.
@available(macOS 26.0, *)
public typealias Vector4Int = Vector<4, Int>
#endif

@available(macOS 26.0, *)
public extension Vector where N == 4 {
    /// Component of the vector in the X axis.
    var x: Scalar {
        get { elements[0] }
        set { elements[0] = newValue }
    }
    /// Component of the vector in the Y axis.
    var y: Scalar {
        get { elements[1] }
        set { elements[1] = newValue }
    }
    /// Component of the vector in the Z axis.
    var z: Scalar {
        get { elements[2] }
        set { elements[2] = newValue }
    }
    /// Component of the vector in the W axis.
    var w: Scalar {
        get { elements[3] }
        set { elements[3] = newValue }
    }
}
