//
//  Cell.swift
//  Mathe
//
//  Created by Martônio Júnior on 25/09/2026.
//

public import MatheCoordinates

/// Two-dimensional box.
@available(macOS 26.0.0, *)
public typealias Rect<C: CoordinateSystem> = Placed<RectShape<C.Scalar>, C> where C.Scalar: AdditiveArithmetic
@available(macOS 26.0.0, *)
public typealias RectShape<Scalar: AdditiveArithmetic> = CellShaped.ByExtent<2, Scalar>
/// Three-dimensional box.
@available(macOS 26.0.0, *)
public typealias Box<C: CoordinateSystem> = Placed<BoxShape<C.Scalar>, C> where C.Scalar: AdditiveArithmetic
@available(macOS 26.0.0, *)
public typealias BoxShape<Scalar: AdditiveArithmetic> = CellShaped.ByExtent<3, Scalar>

public enum CellShaped {}
