//
//  Simplex+Point.swift
//  Mathe
//
//  Created by Martônio Júnior on 23/09/2026.
//

@available(macOS 26.0.0, *)
public typealias Point<Vertex> = Simplex<0, Vertex>

@available(macOS 26.0.0, *)
public extension Simplex where n == 0 {
    /// Value associated with the point.
    var rawValue: Vertex { end }
}

@available(macOS 26.0.0, *)
public extension Simplex where n == 0, Vertex: Equatable {
    // swiftlint:disable:next missing_docs
    static func ~= (lhs: Self, rhs: Vertex) -> Bool {
        lhs.end == rhs
    }
}
