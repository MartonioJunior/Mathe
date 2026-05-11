//
//  Pointwise+Operators.swift
//  Core
//
//  Created by Martônio Júnior on 28/09/2025.
//

// MARK: Addition Precedence
infix operator .+: AdditionPrecedence
infix operator .-: AdditionPrecedence

// MARK: Comparison Precedence
infix operator .<: ComparisonPrecedence
infix operator .<=: ComparisonPrecedence
infix operator .>: ComparisonPrecedence
infix operator .>=: ComparisonPrecedence

// MARK: Multiplication Precedence
infix operator .*: MultiplicationPrecedence
infix operator ./: MultiplicationPrecedence
