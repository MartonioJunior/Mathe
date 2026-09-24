//
//  GeographicCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

public import MatheSIMD

/// Coordinate that defines a location in the real world
public struct GeographicCoordinate {
    // swiftlint:disable:next missing_docs
    public typealias Scalar = Double
    // MARK: Variables
    var latitude: Scalar
    var longitude: Scalar
}

// MARK: Self: CoordinateSystem
#if swift(>=6.2)
@available(macOS 26.0, *)
extension GeographicCoordinate: CoordinateSystem {
    // swiftlint:disable:next missing_docs
    public typealias Components = Vector<2, Double>
    // swiftlint:disable:next missing_docs
    public var components: Components { .init([latitude, longitude]) }
    // swiftlint:disable:next missing_docs
    public func offset(by displacement: Components) -> GeographicCoordinate {
        let base = components .+ displacement
        return .init(latitude: base[0], longitude: base[1])
    }
}
#else
extension GeographicCoordinate: CoordinateSystem {
    // swiftlint:disable:next missing_docs
    public typealias Components = DisplacementFor<Self>
    // swiftlint:disable:next missing_docs
    public var components: Components { .init(offset: self) }
    // swiftlint:disable:next missing_docs
    public func offset(by displacement: Components) -> GeographicCoordinate {
        .init(
            latitude: latitude + displacement.offset.latitude,
            longitude: longitude + displacement.offset.longitude
        )
    }
}
#endif

// MARK: Self: Pointwise
extension GeographicCoordinate: Pointwise {
    // swiftlint:disable:next missing_docs
    public var scalarCount: Int { 2 }
    // swiftlint:disable:next missing_docs
    public subscript(index: Int) -> Scalar {
        get {
            switch index {
                case 0: latitude
                case 1: longitude
                default: fatalError("Invalid index accessed")
            }
        }
        set {
            switch index {
                case 0: latitude = newValue
                case 1: longitude = newValue
                default: fatalError("Invalid index mutated")
            }
        }
    }
    // swiftlint:disable:next missing_docs
    public init(scalars: [Scalar]) {
        self.init(latitude: scalars[0], longitude: scalars[1])
    }
}

// MARK: CoordinateSystem (EX)
public extension CoordinateSystem where Self == GeographicCoordinate {
    /// Creates a new geographic coordinate
    /// - Parameters:
    ///   - lat: Latitude
    ///   - lng: Longitude
    ///
    /// - Returns: A new `GeographicCoordinate` instance
    static func geographic(lat: Scalar, lng: Scalar) -> Self {
        .init(latitude: lat, longitude: lng)
    }

    @available(macOS 26.0, *)
    static func geographic(_ vector: Vector<2, Double>) -> Self {
        .geographic(lat: vector[0], lng: vector[1])
    }
}
