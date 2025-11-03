//
//  Matrix+Numerics.swift
//  Trinkets
//
//  Created by Martônio Júnior on 06/10/2025.
//

public import Numerics

@available(macOS 26.0.0, *)
public extension Matrix where Rows == 4, Columns == 4, Element: Real {
    mutating func rotate(x angle: Element) -> Self {
        var matrix = self
        let cosAngle = Element.cos(angle)
        let sinAngle = Element.sin(angle)
        matrix[5] = cosAngle
        matrix[6] = -sinAngle
        matrix[9] = sinAngle
        matrix[10] = cosAngle
        return matrix
    }

    mutating func rotate(y angle: Element) -> Self {
        var matrix = self
        let cosAngle = Element.cos(angle)
        let sinAngle = Element.sin(angle)
        matrix[0] = cosAngle
        matrix[2] = sinAngle
        matrix[8] = -sinAngle
        matrix[10] = cosAngle
        return matrix
    }

    mutating func rotate(z angle: Element) -> Self {
        var matrix = self
        let cosAngle = Element.cos(angle)
        let sinAngle = Element.sin(angle)
        matrix[0] = cosAngle
        matrix[1] = -sinAngle
        matrix[4] = sinAngle
        matrix[5] = cosAngle
        return matrix
    }

    mutating func rotateOnAxis(_ vector: Vector<3, Element>, angle: Element) -> Self {
        var matrix = self
        let cosAngle = Element.cos(angle)
        let sinAngle = Element.sin(angle)
        let oneMinusCos = 1 - cosAngle
        matrix[0] = cosAngle + vector.x * vector.x * oneMinusCos
        matrix[1] = vector.x * vector.y * oneMinusCos - vector.z * sinAngle
        matrix[2] = vector.x * vector.z * oneMinusCos + vector.y * sinAngle
        matrix[4] = vector.y * vector.x * oneMinusCos + vector.z * sinAngle
        matrix[5] = cosAngle + vector.y * vector.y * oneMinusCos
        matrix[6] = vector.y * vector.z * oneMinusCos - vector.x * sinAngle
        matrix[8] = vector.z * vector.x * oneMinusCos - vector.y * sinAngle
        matrix[9] = vector.z * vector.y * oneMinusCos + vector.x * sinAngle
        matrix[10] = cosAngle + vector.z * vector.z * oneMinusCos
        return matrix
    }
}
