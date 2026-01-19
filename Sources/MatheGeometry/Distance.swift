//
//  Distance.swift
//  Core
//
//  Created by Martônio Júnior on 28/09/2025.
//

public struct Distance<Point, T> {
    var calculate: (Point, Point) -> T
}

// MARK: DotSyntax
public extension Distance where Point: Numeric, Point.Magnitude == T {
    static var euclidean: Self {
        .init { ($0 - $1).magnitude }
    }
}
