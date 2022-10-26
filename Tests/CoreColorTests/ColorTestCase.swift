//
//  ColorTestCase.swift
//  CoreColorTests
//
//  Created by yukonblue on 10/19/2022.
//

import XCTest
@testable import CoreColor

class ColorTestCase: XCTestCase {

    func check_conversion<T: Color, U: Color>(_ src: T, conversion: (T) -> U, check: (U, T) throws -> Void) throws {
        try check(conversion(src), src)
    }

    func assertIsSameRGB(_ a: RGB, _ b: RGB) throws {
        XCTAssertEqual(a.r, b.r, accuracy: 1e-5)
        XCTAssertEqual(a.g, b.g, accuracy: 1e-1)
        XCTAssertEqual(a.b, b.b, accuracy: 1e-5)
        XCTAssertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        XCTAssertEqual(a.space, b.space)
    }

    func assertIsSameXYZ(_ a: XYZ, _ b: XYZ) throws {
        XCTAssertEqual(a.x, b.x, accuracy: 1e-5)
        XCTAssertEqual(a.y, b.y, accuracy: 1e-5)
        XCTAssertEqual(a.z, b.z, accuracy: 1e-5)
        XCTAssertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        XCTAssertEqual(a.space, b.space)
    }

    func assertIsSameLUV(_ a: LUV, _ b: LUV) throws {
        assertEqual(a.l, b.l, accuracy: 1e-5)
        assertEqual(a.u, b.u, accuracy: 1e-4)
        assertEqual(a.v, b.v, accuracy: 1e-4) // TODO: more accuracy
        assertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        XCTAssertEqual(a.space, b.space)
    }

    func assertIsSameLAB(_ a: LAB, _ b: LAB) throws {
        XCTAssertEqual(a.l, b.l, accuracy: 1e-5)
        XCTAssertEqual(a.a, b.a, accuracy: 1e-4) // TODO: Need more accuracy
        XCTAssertEqual(a.b, b.b, accuracy: 1e-5)
        XCTAssertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        XCTAssertEqual(a.space, b.space)
    }

    func assertIsSameHSV(_ a: HSV, _ b: HSV) throws {
        assertEqual(a.h, b.h, accuracy: 1e-5)
        assertEqual(a.s, b.s, accuracy: 1e-5)
        assertEqual(a.v, b.v, accuracy: 1e-4) // TODO: more accuracy
        assertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        XCTAssertEqual(a.space, b.space)
    }

    func assertIsSameHSL(_ a: HSL, _ b: HSL) throws {
        assertEqual(a.h, b.h, accuracy: 1e-6)
        assertEqual(a.s, b.s, accuracy: 1e-5)
        assertEqual(a.l, b.l, accuracy: 1e-5)
        assertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        XCTAssertEqual(a.space, b.space)
    }

    func assertIsSameCMYK(_ a: CMYK, _ b: CMYK) throws {
        assertEqual(a.c, b.c, accuracy: 1e-5)
        assertEqual(a.m, b.m, accuracy: 1e-5)
        assertEqual(a.y, b.y, accuracy: 1e-5)
        assertEqual(a.k, b.k, accuracy: 1e-5)
        assertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        XCTAssertEqual(a.space, b.space)
    }

    private func assertEqual(_ a: Float, _ b: Float, accuracy: Float = 1e-5) {
        switch (a.isNaN, b.isNaN) {
        case (true, true):
            break
        default:
            XCTAssertEqual(a, b, accuracy: accuracy)
        }
    }
}
