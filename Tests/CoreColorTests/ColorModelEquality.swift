//
//  ColorModelEquality.swift
//  CoreColorTests
//
//  Created by yukonblue on 2024-03-02.
//

import XCTest

@testable import CoreColor

protocol ColorModelEquality {

    associatedtype T: Color

    func checkEquals(lhs: T, rhs: T, accuracy: Float)
}

extension ColorModelEquality {

    func assertEqual(_ a: Float, _ b: Float, accuracy: Float = 1e-5) {
        switch (a.isNaN, b.isNaN) {
        case (true, true):
            break
        default:
            XCTAssertEqual(a, b, accuracy: accuracy)
        }
    }
}

struct CMYKEquality: ColorModelEquality {

    func checkEquals(lhs: CMYK, rhs: CMYK, accuracy: Float = 1e-5) {
        assertEqual(lhs.c, rhs.c, accuracy: accuracy)
        assertEqual(lhs.m, rhs.m, accuracy: accuracy)
        assertEqual(lhs.y, rhs.y, accuracy: accuracy)
        assertEqual(lhs.k, rhs.k, accuracy: accuracy)
        assertEqual(lhs.alpha, rhs.alpha, accuracy: accuracy)
        XCTAssertEqual(lhs.space, rhs.space)
    }
}
