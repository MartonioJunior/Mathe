//
//  OverlapScore+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 23/09/2026.
//

public import MatheRange

public extension OverlapScore {
    /// Boundary A overlaps B by a certain percentage.
    /// - Parameter percentage: Overlap score between shapes.
    static func intersect(_ percentage: Saturated<Double>) -> Self {
        .init(rawValue: percentage.wrappedValue)
    }
}
