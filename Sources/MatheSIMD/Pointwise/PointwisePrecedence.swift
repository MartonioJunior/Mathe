//
//  PointwiseOperators.swift
//  Core
//
//  Created by Martônio Júnior on 28/09/2025.
//

// MARK: Precedence Group
precedencegroup PointwisePrecedence {
    higherThan: AssignmentPrecedence
}

// MARK: Operators
infix operator .+: PointwisePrecedence
infix operator .-: PointwisePrecedence
infix operator .*: PointwisePrecedence
infix operator ./: PointwisePrecedence
