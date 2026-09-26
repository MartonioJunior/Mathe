//
//  Cylinder+RadiusHeight.swift
//  Mathe
//
//  Created by Martônio Júnior on 26/09/2026.
//

public import MatheCoordinates
public import MatheSIMD

public extension CylinderShaped {
    // Assumes the origin to be the bottom of the shape.
    struct RadiusHeight<Scalar: Numeric & Comparable> {
        var radius: Scalar
        var height: Scalar
    }
}

// MARK: Self: Shape
@available(macOS 26.0, *)
extension CylinderShaped.RadiusHeight: Shape {
    // swiftlint:disable:next missing_docs
    public typealias Coordinate = CartesianCoordinate<3, Scalar>
    // swiftlint:disable:next missing_docs
    public func isOutline(for point: Coordinate) -> Bool {
        // typealias Circle = Placed<CircleModel<Scalar>, Coordinate>
        guard ((.zero)...height) ~= point[1] else { return false }

        let coordinate = CartesianCoordinate<2, Scalar>(scalars: [0, 0])
        let model = CircleShape(radius: radius)
        let circle = Circle(model, in: coordinate)
        return circle.isOutline(for: .init(scalars: [point[0], point[2]]))
    }
}

// MARK: Placed (EX)
public extension Placed where Coordinate: Pointwise, Element == CylinderShaped.RadiusHeight<Coordinate.Scalar> {
    var bottom: Coordinate { position }
    var top: Coordinate { position + element.height }
}
