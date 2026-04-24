//
//  CoordinateSystem+Numerics.swift
//  Mathe
//
//  Created by Martônio Júnior on 23/04/2026.
//

#if Numerics
import Numerics

public extension PolarCoordinate {
    func toCartesian() -> CartesianCoordinate {
        .cartesian(x: radius * Value.cos(angle), y: radius * Value.sin(angle))
    }
}
#endif
