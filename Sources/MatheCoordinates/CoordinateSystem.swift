//
//  CoordinateSystem.swift
//  Trinkets
//
//  Created by Martônio Júnior on 12/07/2025.
//

/// Data structure that defines a dimensional positioning coordinate
public protocol CoordinateSystem {
    /// Vector containing all components that describe this position
    associatedtype Components = Never
    /// Type representing the numerical value used for one component
    associatedtype Scalar: AdditiveArithmetic = Double

    /// Collection of ordered numbers that uniquely describe this coordinate position
    var components: Components { get }
}

// MARK: Self.Value == Never
public extension CoordinateSystem where Components == Never {
    // swiftlint:disable:next missing_docs
    var components: Never { fatalError("Components vector was not defined!") }
}
