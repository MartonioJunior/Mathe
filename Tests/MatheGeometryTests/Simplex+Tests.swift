//
//  Simplex+Tests.swift
//  Mathe
//
//  Created by Martônio Júnior on 23/09/2026.
//

@testable import MatheGeometry
import MatheRange
import Testing

struct SimplexTests {

    // MARK: Self: Polygon
    struct ConformsToPolygon {
        @Test("Obtains the simplex's edges")
        func edges() {
            if #available(macOS 26, *) {
                let sut = Simplex<2, Int>(.init([1, 2]), end: 3)
                let expected = [
                    Extent<Int>(from: 1, to: 2),
                    Extent<Int>(from: 1, to: 3),
                    Extent<Int>(from: 2, to: 3)
                ]
                #expect(sut.edges.elementsEqual(expected))
            }

            if #available(macOS 26, *) {
                let sut = Simplex<3, Int>(.init([1, 2, 3]), end: 4)
                let expected = [
                    Extent<Int>(from: 1, to: 2),
                    Extent<Int>(from: 1, to: 3),
                    Extent<Int>(from: 1, to: 4),
                    Extent<Int>(from: 2, to: 3),
                    Extent<Int>(from: 2, to: 4),
                    Extent<Int>(from: 3, to: 4)
                ]
                #expect(sut.edges.elementsEqual(expected))
            }
        }

        @Test("Obtains the simplex's vertices")
        func vertices() {
            if #available(macOS 26, *) {
                let sut = Simplex<2, Int>(.init([1, 2]), end: 3)
                let expected = [1, 2, 3]
                #expect(sut.vertices.elementsEqual(expected))
            }

            if #available(macOS 26, *) {
                let sut = Simplex<2, Int>(.init([1, 2, 3]), end: 4)
                let expected = [1, 2, 3, 4]
                #expect(sut.vertices.elementsEqual(expected))
            }
        }
    }
}
