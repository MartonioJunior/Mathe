//
//  CoordinateSystem.swift
//  Trinkets
//
//  Created by Martônio Júnior on 12/07/2025.
//

public import MatheSIMD

/// Data structure that defines a dimensional positioning coordinate
public protocol CoordinateSystem {
    /// Displacement vector used to move the coordinate.
    /// 
    /// Contains all components that describe a coordinate.
    associatedtype Components: Pointwise = DisplacementFor<Self>
    /// Type representing the numerical value used for one component.
    associatedtype Scalar: AdditiveArithmetic = Double
    // MARK: Variables
    /// Displacement from the origin that uniquely describes this coordinate position.
    var components: Components { get }
    // MARK: Methods
    /// Applies a displacement to a coordinate.
    /// - Parameter displacement: Displacement vector. 
    /// - Returns: Offset coordinate.
    func offset(by displacement: Components) -> Self
}

// MARK: Default Implementation
public extension CoordinateSystem where Self: Pointwise, Scalar == Components.Scalar, Scalar: AdditiveArithmetic {
    // swiftlint:disable:next missing_docs
    func offset(by displacement: Components) -> Self {
        pointwise(displacement, merge: +)
    }
}
