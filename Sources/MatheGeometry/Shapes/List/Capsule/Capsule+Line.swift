//
//  Capsule+Line.swift
//  Mathe
//
//  Created by Martônio Júnior on 26/09/2026.
//

public import MatheCoordinates
import MatheSIMD

public extension CapsuleShaped {
    @available(macOS 26.0.0, *)
    struct Line<let n: Int, Scalar: FloatingPoint> {
        var line: LineSegment<n, Scalar>
        var radius: Scalar

        var height: Scalar { (line.upperBound .- line.lowerBound).magnitudeSquared }
    }
}

// MARK: Self: Shape
@available(macOS 26.0.0, *)
extension CapsuleShaped.Line: Shape {
    // swiftlint:disable:next missing_docs
    public typealias Coordinate = CartesianCoordinate<n, Scalar>

    @_disfavoredOverload
    public func isOutline(for point: Coordinate) -> Bool {
        fatalError("No implementation available for this number of dimensions")
    }
}

@available(macOS 26.0.0, *)
extension CapsuleShaped.Line where n == 2 {
    // swiftlint:disable:next missing_docs
    public func isOutline(for point: Coordinate) -> Bool {
        typealias Circle = Placed<NSphere<n, Scalar>, Coordinate>
        let origin = Coordinate(scalars: repeatElement(.zero, count: n).map(\.self))
        var top = origin
        top[1] += height
        let model = NSphere<n, Scalar>(radius: radius)

        // Top circle check
        if point[1] >= top[1] {
            let topSphere = Circle(model, in: top)
            return topSphere.isOutline(for: point)
        }

        // Bottom circle check
        if point[1] <= origin[1] {
            let bottomSphere = Circle(model, in: origin)
            return bottomSphere.isOutline(for: point)
        }

        // Rectangle check
        let rect = CellShaped.ByExtent<2, Scalar>(extents: .init([radius, height / 2]))
        return rect.isOutline(for: point)
    }
}

@available(macOS 26.0.0, *)
extension CapsuleShaped.Line where n == 3 {
    // swiftlint:disable:next missing_docs
    public func isOutline(for point: Coordinate) -> Bool {
        typealias Sphere = Placed<NSphere<n, Scalar>, Coordinate>
        let origin = Coordinate(scalars: repeatElement(.zero, count: n).map(\.self))
        var top = origin
        top[1] += height
        let model = NSphere<n, Scalar>(radius: radius)

        // Top sphere check
        if point[1] >= top[1] {
            let topSphere = Sphere(model, in: top)
            return topSphere.isOutline(for: point)
        }

        // Bottom sphere check
        if point[1] <= origin[1] {
            let bottomSphere = Sphere(model, in: origin)
            return bottomSphere.isOutline(for: point)
        }

        // Cylinder check
        let cylinder = CylinderShaped.RadiusHeight(radius: radius, height: height)
        return cylinder.isOutline(for: point)
    }
}
