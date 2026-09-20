//
//  Vector+Algebra.swift
//  Mathe
//
//  Created by Martônio Júnior on 20/09/2026.
//

// MARK: Self: AdditiveArithmetic
@available(macOS 26.0, *)
extension Vector: AdditiveArithmetic where Scalar: AdditiveArithmetic {
    // swiftlint:disable:next missing_docs
    public static var zero: Self { .repeating(.zero) }
    // swiftlint:disable:next missing_docs
    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.pointwise(rhs, merge: +)
    }
    // swiftlint:disable:next missing_docs
    public static func - (lhs: Self, rhs: Self) -> Self {
        lhs.pointwise(rhs, merge: -)
    }
}
