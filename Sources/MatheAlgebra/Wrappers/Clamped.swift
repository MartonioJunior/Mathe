//
//  Clamped.swift
//  Mathe
//
//  Created by Martônio Júnior on 02/05/2026.
//

public import MatheRange

/// Data structure that represents a value that exists within a gamut.
@propertyWrapper
public struct Clamped<B: Gamut> where B.Bound: Comparable {
    // MARK: Variables
    var gamut: B
    private var rawValue: B.Bound
    /// Value clamped to the current gamut.
    public var wrappedValue: B.Bound {
        get { rawValue }
        set { rawValue = gamut.clamp(newValue) }
    }
    // MARK: Initializers
    /// Creates a new value that is clamped to a specified gamut.
    /// - Parameters:
    ///   - value: Value to be clamped.
    ///   - gamut: Gamut used for clamping.
    public init(wrappedValue value: B.Bound, in gamut: B) {
        self.gamut = gamut
        self.rawValue = gamut.clamp(value)
    }
}
