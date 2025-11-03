//
//  GraphEdge+Utilities.swift
//  Mathe
//
//  Created by Martônio Júnior on 10/10/2025.
//

public import Graphs

public extension GraphEdge {
    var reversed: Self {
        .init(source: destination, destination: source, value: value)
    }
}
