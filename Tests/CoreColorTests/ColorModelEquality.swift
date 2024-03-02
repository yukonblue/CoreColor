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

struct HSLEquality: ColorModelEquality {

    func checkEquals(lhs a: HSL, rhs b: HSL, accuracy: Float = 1e-5) {
        assertEqual(a.h, b.h, accuracy: 1e-6)
        assertEqual(a.s, b.s, accuracy: 1e-5)
        assertEqual(a.l, b.l, accuracy: 1e-5)
        assertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        XCTAssertEqual(a.space, b.space)
    }
}

struct HSVEquality: ColorModelEquality {

    func checkEquals(lhs a: HSV, rhs b: HSV, accuracy: Float = 1e-5) {
        assertEqual(a.h, b.h, accuracy: 1e-5)
        assertEqual(a.s, b.s, accuracy: 1e-5)
        assertEqual(a.v, b.v, accuracy: 1e-4) // TODO: more accuracy
        assertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        XCTAssertEqual(a.space, b.space)
    }
}

struct LABEquality: ColorModelEquality {

    func checkEquals(lhs a: LAB, rhs b: LAB, accuracy: Float = 1e-5) {
        XCTAssertEqual(a.l, b.l, accuracy: 1e-5)
        XCTAssertEqual(a.a, b.a, accuracy: 1e-4) // TODO: Need more accuracy
        XCTAssertEqual(a.b, b.b, accuracy: 1e-5)
        XCTAssertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        XCTAssertEqual(a.space, b.space)
    }
}

struct LUVEquality: ColorModelEquality {

    func checkEquals(lhs a: LUV, rhs b: LUV, accuracy: Float = 1e-5) {
        assertEqual(a.l, b.l, accuracy: 1e-5)
        assertEqual(a.u, b.u, accuracy: 1e-4)
        assertEqual(a.v, b.v, accuracy: 1e-4) // TODO: more accuracy
        assertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        XCTAssertEqual(a.space, b.space)
    }
}

struct XYZEquality: ColorModelEquality {

    func checkEquals(lhs a: XYZ, rhs b: XYZ, accuracy: Float = 1e-5) {
        XCTAssertEqual(a.x, b.x, accuracy: 1e-5)
        XCTAssertEqual(a.y, b.y, accuracy: 1e-5)
        XCTAssertEqual(a.z, b.z, accuracy: 1e-5)
        XCTAssertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        XCTAssertEqual(a.space, b.space)
    }
}

struct RGBEquality: ColorModelEquality {

    func checkEquals(lhs a: RGB, rhs b: RGB, accuracy: Float = 1e-5) {
        XCTAssertEqual(a.r, b.r, accuracy: 1e-5)
        XCTAssertEqual(a.g, b.g, accuracy: 1e-1)
        XCTAssertEqual(a.b, b.b, accuracy: 1e-5)
        XCTAssertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        XCTAssertEqual(a.space, b.space)
    }
}
