//
//  Capsule.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/05/2026.
//

public import MatheCoordinates

@available(macOS 26.0.0, *)
public typealias Capsule<C: CoordinateSystem> = Placed<CapsuleShaped.ByExtent<C.Scalar>, C> where C.Scalar: Numeric

public enum CapsuleShaped {}
