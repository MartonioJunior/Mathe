//
//  AABB.swift
//  Mathe
//
//  Created by Martônio Júnior on 05/05/2026.
//

public import MatheCoordinates

// MARK: Aliases
@available(macOS 26.0.0, *)
public typealias AABB = AxisAlignedBoundingBox
@available(macOS 26.0.0, *)
public typealias AxisAlignedBoundingBox<let n: Int, Scalar: AdditiveArithmetic> = Placed<CellShaped.ByExtent<n, Scalar>, CartesianCoordinate<n, Scalar>>
