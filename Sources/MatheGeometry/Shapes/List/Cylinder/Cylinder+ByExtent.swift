//
//  Cylinder+ByExtent.swift
//  Mathe
//
//  Created by Martônio Júnior on 26/09/2026.
//

public import MatheSIMD

public extension CylinderShaped {
    @available(macOS 26.0, *)
    struct ByExtent<Scalar: Numeric> {
        var extents: Vector<2, Scalar>

        public var radius: Scalar { extents[0] }
        public var height: Scalar { extents[1] * 2 }
    }
}

// MARK: Placed (EX)
@available(macOS 26.0, *)
public extension Placed where Coordinate: Pointwise, Element == CylinderShaped.ByExtent<Coordinate.Scalar> {
    var bottom: Coordinate { position - element.extents[1] }
    var top: Coordinate { position + element.extents[1] }
}

@available(macOS 26.0, *)
public extension Placed where Element == CylinderShaped.ByExtent<Coordinate.Scalar> {
    var box: Box<Coordinate> {
        .init(.init([element.extents.x, element.extents.y, element.extents.x]), in: position)
    }
}
