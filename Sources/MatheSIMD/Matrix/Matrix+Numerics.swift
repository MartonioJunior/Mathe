//
//  Matrix+Numerics.swift
//  Trinkets
//
//  Created by Martônio Júnior on 06/10/2025.
//

#if Numerics
public import Numerics

@available(macOS 26.0.0, *)
public extension Matrix where Scalar: Numeric & ElementaryFunctions & AlgebraicField {
    /// Unsigned determinant of a matrix.
    /// 
    /// Works as a replacement for the traditional determinant in cases where the matrix isn't square.
    var unsignedDeterminant: Scalar {
        .sqrt((self * transposed).determinant)
    }
}

@available(macOS 26.0.0, *)
public extension Matrix where Rows == Columns, Scalar: Numeric & ElementaryFunctions & AlgebraicField {
    /// Determinant of a matrix.
    @_disfavoredOverload var determinant: Scalar {
        let length = Rows
        var det: Scalar = 1
        var total: Scalar = 1
        var temp: [Scalar] = []
        var copy = self

        for i in 0..<length {
            guard let nonZeroIndex = self[r: i].firstIndex(where: { $0 != .zero }) else {
                continue
            }

            if nonZeroIndex != i {
                for j in 0..<length {
                    let temp = copy[r: nonZeroIndex, c: j]
                    copy[r: nonZeroIndex, c: j] = copy[r: j, c: i]
                    copy[r: j, c: i] = temp
                }

                det *= .pow(-1, nonZeroIndex - i)
            }

            temp = (0..<length).map { copy[r: $0, c: i] }

            for j in (i + 1)..<length {
                let diagonalElement = temp[i]
                let nextRowElement = copy[r: i, c: j]

                for k in 0..<length {
                    copy[r: k, c: j] = diagonalElement * copy[r: k, c: j] - nextRowElement * temp[k]
                }

                total *= diagonalElement
            }
        }

        for i in 0..<length {
            det *= copy[r: i, c: i]
        }

        return det / total
    }
}

@available(macOS 26.0.0, *)
public extension Matrix where Rows == 4, Columns == 4, Scalar: Real {
    /// Creates a rotation matrix that represents a rotation in the X axis.
    /// - Parameter angle: Angle of the rotation.
    /// - Returns: A new rotation matrix.
    static func rotationMatrix(x angle: Scalar) -> Self {
        var matrix = identity
        let cosAngle = Scalar.cos(angle)
        let sinAngle = Scalar.sin(angle)
        matrix[r: 1, c: 1] = cosAngle
        matrix[r: 1, c: 2] = -sinAngle
        matrix[r: 2, c: 1] = sinAngle
        matrix[r: 2, c: 2] = cosAngle
        return matrix
    }
    /// Creates a rotation matrix that represents a rotation in the Y axis.
    /// - Parameter angle: Angle of the rotation.
    /// - Returns: A new rotation matrix.
    static func rotationMatrix(y angle: Scalar) -> Self {
        var matrix = identity
        let cosAngle = Scalar.cos(angle)
        let sinAngle = Scalar.sin(angle)
        matrix[r: 0, c: 0] = cosAngle
        matrix[r: 0, c: 2] = sinAngle
        matrix[r: 2, c: 0] = -sinAngle
        matrix[r: 2, c: 2] = cosAngle
        return matrix
    }
    /// Creates a rotation matrix that represents a rotation in the Z axis.
    /// - Parameter angle: Angle of the rotation.
    /// - Returns: A new rotation matrix.
    static func rotationMatrix(z angle: Scalar) -> Self {
        var matrix = identity
        let cosAngle = Scalar.cos(angle)
        let sinAngle = Scalar.sin(angle)
        matrix[r: 0, c: 0] = cosAngle
        matrix[r: 0, c: 1] = -sinAngle
        matrix[r: 1, c: 0] = sinAngle
        matrix[r: 1, c: 1] = cosAngle
        return matrix
    }
    /// Creates a rotation matrix that represents a rotation in any given axis.
    /// - Parameters:
    ///   - vector: Axis of rotation.
    ///   - angle: Angle of th rotation.
    ///
    /// - Returns: A new rotation matrix.
    static func rotatedOnAxis(_ axis: Vector<3, Scalar>, angle: Scalar) -> Self {
        var matrix = identity
        let cosAngle = Scalar.cos(angle)
        let sinAngle = Scalar.sin(angle)
        let oneMinusCos = 1 - cosAngle
        matrix[r: 0, c: 0] = cosAngle + axis.x * axis.x * oneMinusCos
        matrix[r: 0, c: 1] = axis.x * axis.y * oneMinusCos - axis.z * sinAngle
        matrix[r: 0, c: 2] = axis.x * axis.z * oneMinusCos + axis.y * sinAngle
        matrix[r: 1, c: 0] = axis.y * axis.x * oneMinusCos + axis.z * sinAngle
        matrix[r: 1, c: 1] = cosAngle + axis.y * axis.y * oneMinusCos
        matrix[r: 1, c: 2] = axis.y * axis.z * oneMinusCos - axis.x * sinAngle
        matrix[r: 2, c: 0] = axis.z * axis.x * oneMinusCos - axis.y * sinAngle
        matrix[r: 2, c: 1] = axis.z * axis.y * oneMinusCos + axis.x * sinAngle
        matrix[r: 2, c: 2] = cosAngle + axis.z * axis.z * oneMinusCos
        return matrix
    }
}
#endif
