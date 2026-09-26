//
//  Cone.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/05/2026.
//

public import MatheCoordinates

public typealias Cone<C: CoordinateSystem> = Placed<ConeShaped.RadiusHeight<C.Scalar>, C> where C.Scalar: Numeric

public enum ConeShaped {}
