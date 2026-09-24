//
//  MalleableCoordinate.swift
//  Mathe
//
//  Created by Martônio Júnior on 25/11/2025.
//

public import MatheSIMD
/// Coordinate system where it's position can be represented by any number of values
/// 
/// This allows the coordinate to change dimensions with no issues
public struct MalleableCoordinate<Scalar: AdditiveArithmetic> {
    // MARK: Variables
    public var values: [Scalar]

    // MARK: Initializers
    public init(_ values: [Scalar]) {
        self.values = values
    }

    // MARK: Subscripts
    public subscript(axis: Int) -> Scalar {
        get { values[axis] }
        set { values[axis] = newValue }
    }
}

// MARK: Self: CoordinateSystem
@available(macOS 26.0, *)
extension MalleableCoordinate: CoordinateSystem {
    // swiftlint:disable:next missing_docs
    public typealias Components = DisplacementFor<Self>
    // swiftlint:disable:next missing_docs
    public var components: Components { .init(offset: self) }
    // swiftlint:disable:next missing_docs
    public func offset(by displacement: Components) -> MalleableCoordinate<Scalar> {
        .init(zip(values, displacement.offset.values).map { $0.0 + $0.1 })
    }
}

// MARK: Self: Pointwise
@available(macOS 26.0, *)
extension MalleableCoordinate: Pointwise {
    // swiftlint:disable:next missing_docs
    public var scalarCount: Int { values.count }
    // swiftlint:disable:next missing_docs
    public init(scalars: [Scalar]) {
        self.init(scalars)
    }
}

// MARK: Self: Equatable
extension MalleableCoordinate: Equatable {}

// MARK: Self: ExpressibleByArrayLiteral
extension MalleableCoordinate: ExpressibleByArrayLiteral {
    // swiftlint:disable:next missing_docs
    public init(arrayLiteral elements: Scalar...) {
        self.init(elements)
    }
}
