//
//  MatrixIndex.swift
//  Trinkets
//
//  Created by Martônio Júnior on 25/04/2025.
//

@available(macOS 26, *)
public struct MatrixIndex<let N: Int> {
    public var elements: Vector<N, Int>

    public subscript(_ index: Int) -> Int {
        get { elements[index] }
        set { elements[index] = newValue }
    }

    public init(_ elements: Vector<N, Int>) {
        self.elements = elements
    }

    public static var zero: Self { .init(.zero) }
}

// MARK: N == 2
@available(macOS 26, *)
public extension MatrixIndex where N == 2 {
    public var column: Int { elements[1] }
    public var row: Int { elements[0] }

    public init(r: Int, c: Int) {
        self.elements = [r, c]
    }
}

// MARK: Self: Comparable
@available(macOS 26, *)
extension MatrixIndex: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        for i in 0..<N {
            if lhs[i] == rhs[i] { continue }

            return lhs[i] < rhs[i]
        }

        return false
    }
}

// MARK: Self: Equatable
@available(macOS 26, *)
extension MatrixIndex: Equatable {}
