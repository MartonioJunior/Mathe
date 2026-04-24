//
//  Prediction.swift
//  Mathe
//
//  Created by Martônio Júnior on 24/04/2026.
//

public struct Prediction<Field, Input, Weight> {
    // MARK: Variables
    var f: (Field, Input) -> Weight

    // MARK: Initializers
    public init(_ f: @escaping (Field, Input) -> Weight) {
        self.f = f
    }
}

// MARK: DotSyntax
public extension Prediction where Field: Gamut, Field.Bound == Input, Input == Weight, Weight: FloatingPoint {
    static var inverseLinear: Self {
        .init {
            if $0.isShortCircuited { return 0 }

            return ($1 - $0.lowerBound) / ($0.upperBound - $0.lowerBound)
        }
    }
}

// MARK: Boundary (EX)
public typealias BoundaryPrediction<B: Boundary, Weight> = Prediction<B, B.Bound, Weight>

public extension Boundary {
    func score<Weight>(_ value: Bound, using algorithm: BoundaryPrediction<Self, Weight>) -> Weight {
        algorithm.f(self, value)
    }
}

