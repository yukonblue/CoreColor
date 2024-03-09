//
//  Clamped.swift
//  CoreColor
//
//  Created by yukonblue on 2024-03-09.
//

import Foundation

@propertyWrapper
struct Clamped<V: Comparable> {

    let wrappedValue: V

    init(wrappedValue: V, range: ClosedRange<V>) {
        self.wrappedValue = max(range.lowerBound, min(range.upperBound, wrappedValue))
    }
}
