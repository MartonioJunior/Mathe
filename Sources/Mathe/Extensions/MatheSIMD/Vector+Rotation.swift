//
//  Vector+Rotation.swift
//  Mathe
//
//  Created by Martônio Júnior on 04/05/2026.
//

#if Numerics
public import Numerics

@available(macOS 26.0, *)
public extension Vector where Scalar: Real {
    func rotate(_ angle: Scalar, axis: Self) -> Self {
        let h = axis * dot(axis)
        return (self .- h) * Scalar.cos(angle) .+ .repeating(Scalar.sin(angle) * axis.cross(self)) .+ h
    }

    func rotate(by quaternion: Quaternion<N, Scalar>) -> Self {
        self * quaternion.rotationMatrix()
    }

    func rotate(around pivot: Self, by rotation: Quaternion<N, Scalar>) -> Self {
        var direction = self .- pivot
        direction = direction.rotate(by: rotation)
        return direction .+ pivot
    }

    static func rotation(basis index: Int, rotatedBy angle: Scalar) -> Self {
        .basis(index).rotate(angle, axis: .basis(index))
    }
}
#endif
