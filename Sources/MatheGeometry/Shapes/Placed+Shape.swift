//
//  Placed+Shape.swift
//  Mathe
//
//  Created by Martônio Júnior on 25/09/2026.
//

public import MatheCoordinates
public import MatheRange
public import MatheSIMD

public typealias PlacedShape<S: Shape> = Placed<S, S.Coordinate>

public struct Placed<Element, Coordinate: CoordinateSystem> {
    /// Element that exists in the coordinate space.
    var element: Element
    /// Position in the coordinate system.
    var position: Coordinate
    /// Places an element in coordinate space.
    /// - Parameters:
    ///   - element: Element that exists in the coordinate space.
    ///   - position: Position in the coordinate system.
    public init(_ element: Element, in position: Coordinate) {
        self.element = element
        self.position = position
    }
}

// MARK: Self: Geometric
extension Placed: Geometric {}

// MARK: Self: Polygon
extension Placed: Polygon where Element: Polygon, Element.Vertices.Element == Coordinate,
Coordinate: Pointwise, Coordinate.Scalar: AdditiveArithmetic {
    // swiftlint:disable:next missing_docs
    public var edges: [Element.Edges.Element] {
        element.edges.map {
            .init(
                from: $0.lowerBound .+ position,
                to: $0.upperBound .+ position
            )
        }
    }
    // swiftlint:disable:next missing_docs
    public var vertices: [Element.Vertices.Element] {
        element.vertices.map { $0 .+ position }
    }
}

// MARK: Self: Shape
extension Placed: Shape where Element: Shape, Element.Coordinate == Coordinate,
Coordinate: Pointwise, Coordinate.Scalar: AdditiveArithmetic {
    // swiftlint:disable:next missing_docs
    public var isClosed: Bool { element.isClosed }
    // swiftlint:disable:next missing_docs
    public func isOutline(for point: Coordinate) -> Bool {
        element.isOutline(for: point .- position)
    }
    // swiftlint:disable:next missing_docs
    public func outline(t: Element.OutlineParameter) -> Coordinate {
        element.outline(t: t) .+ position
    }
}
