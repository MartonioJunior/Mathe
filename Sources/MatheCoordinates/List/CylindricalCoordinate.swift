//
//  CylindricalCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

public import MatheSIMD

/// Coordinate that represents a position based on a cylinder shape
public struct CylindricalCoordinate<Scalar: AdditiveArithmetic> {
    var radius: Scalar
    var angle: Scalar
    var height: Scalar
}

// MARK: DotSyntax
public extension CoordinateSystem {
    @available(macOS 26.0, *)
    static func cylindrical<T: AdditiveArithmetic>(_ vector: Vector<3, T>) -> Self where Self == CylindricalCoordinate<T> {
        .cylindrical(r: vector[0], angle: vector[1], h: vector[2])
    }
}

// MARK: Self: CoordinateSystem
#if swift(>=6.2)
@available(macOS 26.0, *)
extension CylindricalCoordinate: CoordinateSystem {
    // swiftlint:disable:next missing_docs
    public typealias Components = Vector<3, Scalar>
    // swiftlint:disable:next missing_docs
    public var components: Components {
        .init([radius, angle, height])
    }
    // swiftlint:disable:next missing_docs
    public func offset(by displacement: Components) -> Self {
        let base = components .+ displacement
        return .init(radius: base[0], angle: base[1], height: base[2])
    }
}
#else
extension CylindricalCoordinate: CoordinateSystem {
    // swiftlint:disable:next missing_docs
    public typealias Components = DisplacementFor<Self>
    // swiftlint:disable:next missing_docs
    public var components: Components { .init(offset: self) }
    // swiftlint:disable:next missing_docs
    public func offset(by displacement: Components) -> Self {
        .init(
            radius: radius + displacement.offset.radius,
            angle: angle + displacement.offset.angle,
            height: height + displacement.offset.height
        )
    }
}
#endif

// MARK: Self: Pointwise
extension CylindricalCoordinate: Pointwise {
    // swiftlint:disable:next missing_docs
    public var scalarCount: Int { 3 }
    // swiftlint:disable:next missing_docs
    public subscript(index: Int) -> Scalar {
        get {
            switch index {
                case 0: radius
                case 1: angle
                case 2: height
                default: fatalError("Invalid index accessed")
            }
        }
        set {
            switch index {
                case 0: radius = newValue
                case 1: angle = newValue
                case 2: height = newValue
                default: fatalError("Invalid index mutated")
            }
        }
    }
    // swiftlint:disable:next missing_docs
    public init(scalars: [Scalar]) {
        self.init(radius: scalars[0], angle: scalars[1], height: scalars[2])
    }
}

// MARK: CoordinateSystem (EX)
public extension CoordinateSystem {
    /// Creates a new cylindrical coordinate
    /// - Parameters:
    ///   - radius: The radius of the base
    ///   - angle: Angle for the coordinate
    ///   - height: Y position for the coordinate
    ///
    /// - Returns: A new `CylindricalCoordinate` instance
    static func cylindrical<T>(r radius: T, angle: T, h height: T) -> Self where Self == CylindricalCoordinate<T> {
        .init(radius: radius, angle: angle, height: height)
    }
}
