//
//  CoordinateSystem.swift
//  Trinkets
//
//  Created by Martônio Júnior on 12/07/2025.
//

public protocol CoordinateSystem {
    associatedtype Components = Never
    typealias Value = Double

    var components: Components { get }
}

// MARK: Self.Value == Never
public extension CoordinateSystem where Components == Never {
    var components: Never { fatalError("Components vector was not defined!") }
}
