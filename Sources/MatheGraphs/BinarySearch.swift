//
//  BinarySearch.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

import Foundation
import Graphs

public struct BinarySearch<Element> {
    static func binary(_ array: [Element], range: Range<Int>, for target: (Element) -> ComparisonResult) -> Int? {
        if range.lowerBound >= range.upperBound {
            return nil // If we get here, then the search key is not present in the array.
        }

        let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2

        return switch target(array[midIndex]) {
            case .orderedAscending:
                Self.binary(array, range: midIndex + 1 ..< range.upperBound, for: target)
            case .orderedDescending:
                Self.binary(array, range: range.lowerBound..<midIndex, for: target)
            case .orderedSame:
                midIndex
        }
    }
}
