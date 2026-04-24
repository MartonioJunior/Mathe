//
//  Remap.swift
//  Mathe
//
//  Created by Martônio Júnior on 24/04/2026.
//

public struct Remap<Origin, Target, Input, Output> {
    // MARK: Variables
    var f: (Origin, Target, Input) -> Output

    // MARK: Initializers
    public init(_ f: @escaping (Origin, Target, Input) -> Output) {
        self.f = f
    }

    public init<Weight>(
        _ prediction: Prediction<Origin, Input, Weight>,
        interpolation: Interpolation<Target, Weight, Output>
    ) {
        self.init {
            interpolation.f($1, prediction.f($0, $2))
        }
    }
}

// MARK: DotSyntax
public extension Remap where
    Origin: Gamut, Origin.Bound == Input, Input: FloatingPoint,
    Target: Gamut, Target.Bound == Output, Output == Input {
    static var linear: Self {
        .init(.inverseLinear, interpolation: .linear)
    }
}

// MARK: Boundary (EX)
public typealias BoundaryRemap<B1: Boundary, B2: Boundary> = Remap<B1, B2, B1.Bound, B2.Bound>

public extension Boundary {
    func remap<T: Boundary>(
        _ value: Bound,
        to newBoundary: T,
        using algorithm: BoundaryRemap<Self, T>
    ) -> T.Bound {
        algorithm.f(self, newBoundary, value)
    }
}
