//
//  SignedNumeric+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 25/04/2026.
//

public extension SignedNumeric where Self: Comparable {
    func clampMagnitude(_ value: Self) -> Self {
        (-value...value).clamp(self)
    }
}
