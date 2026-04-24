//
//  Interpolation.swift
//  Mathe
//
//  Created by Martônio Júnior on 24/04/2026.
//

public struct Interpolation<Field, Weight, Output> {
    // MARK: Variables
    var f: (Field, Weight) -> Output

    // MARK: Initializers
    public init(_ f: @escaping (Field, Weight) -> Output) {
        self.f = f
    }
}

// MARK: DotSyntax
public extension Interpolation where Field: Gamut, Field.Bound == Output, Output == Weight, Weight: Numeric {
    static var crossFade: Self {
        .init {
            $1 * $0.upperBound + (1 - $1) * $0.lowerBound
        }
    }

    static var linear: Self {
        .init {
            $0.lowerBound + ($0.upperBound - $0.lowerBound) * $1
        }
    }
}

// MARK: Boundary (EX)
public typealias BoundaryInterpolation<B: Boundary, Weight> = Interpolation<B, Weight, B.Bound>

public extension Boundary {
    func interpolate<Weight>(_ algorithm: BoundaryInterpolation<Self, Weight>, t: Weight) -> Bound {
        algorithm.f(self, t)
    }
}
