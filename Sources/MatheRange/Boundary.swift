//
//  Boundary.swift
//  Mathe
//
//  Created by Martônio Júnior on 20/10/2025.
//

public protocol Boundary {
    associatedtype Bound

    static func ~= (lhs: Self, rhs: Bound) -> Bool
}

// MARK: Default Implementation
public extension Boundary {
    func contains(_ bound: Bound) -> Bool { self ~= bound }
}
