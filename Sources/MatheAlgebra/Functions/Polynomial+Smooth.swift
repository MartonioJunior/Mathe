//
//  Smooth.swift
//  Mathe
//
//  Created by Martônio Júnior on 06/05/2026.
//

@available(macOS 26.0, *)
public extension Polynomial where Scalar: Numeric, degree == 2 {
    static var smoothDerivate: Self { [-6, 6] }
}

@available(macOS 26.0, *)
public extension Polynomial where Scalar: Numeric, degree == 3 {
    /// Also known as a smooth step
    static var smooth: Self { [-2, 3] }
}

@available(macOS 26.0, *)
public extension Polynomial where Scalar: Numeric, degree == 4 {
    static var smooth5Derivate: Self { [1, -60, 30] }
}

@available(macOS 26.0, *)
public extension Polynomial where Scalar: Numeric, degree == 5 {
    /// Also known as smoother step
    static var smooth5: Self { [6, -15, 10] }
}

@available(macOS 26.0, *)
public extension Polynomial where Scalar: Numeric, degree == 6 {
    static var smooth7Derivate: Self { [-140, 420, -420, 140] }
}

@available(macOS 26.0, *)
public extension Polynomial where Scalar: Numeric, degree == 7 {
    static var smooth7: Self { [-20, 70, -84, 35] }
}

@available(macOS 26.0, *)
public extension Polynomial where Scalar: Numeric, degree == 8 {
    static var smooth9Derivate: Self { [630, -2520, 3780, -2520, 630] }
}

@available(macOS 26.0, *)
public extension Polynomial where Scalar: Numeric, degree == 9 {
    static var smooth9: Self { [70, -315, 540, -420, 126] }
}

@available(macOS 26.0, *)
public extension Polynomial where Scalar: Numeric, degree == 10 {
    static var smooth11Derivate: Self { [-2772, 13860, -27720, 27720, -13860, 2772] }
}

@available(macOS 26.0, *)
public extension Polynomial where Scalar: Numeric, degree == 11 {
    static var smooth11: Self { [-252, 1386, -3080, 3465, -1980, 462] }
}
