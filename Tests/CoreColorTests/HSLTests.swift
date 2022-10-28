//
//  HSLTests.swift
//  CoreColorTests
//
//  Created by yukonblue on 10/16/2022.
//

import XCTest
@testable import CoreColor

class HSLTests: ColorTestCase {

    func test_HSL_to_RGB() throws {
        try check_HSL_to_RGB(hsl: HSL(h: Float.nan, s: 0.00, l: 0.00, alpha: 1.0),
                             rgb: RGB(r: 0.00, g: 0.00, b: 0.00, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_HSL_to_RGB(hsl: HSL(h: 64.80, s: 0.18, l: 0.18, alpha: 1.0),
                             rgb: RGB(r: 0.207216, g: 0.2124, b: 0.1476, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_HSL_to_RGB(hsl: HSL(h: 144.00, s: 0.50, l: 0.60, alpha: 1.0),
                             rgb: RGB(r: 0.4, g: 0.8, b: 0.56, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_HSL_to_RGB(hsl: HSL(h: Float.nan, s: 0.00, l: 1.00, alpha: 1.0),
                             rgb: RGB(r: 1.00, g: 1.00, b: 1.00, alpha: 1.0, space: RGBColorSpaces.sRGB))
    }

    func check_HSL_to_RGB(hsl: HSL, rgb: RGB) throws {
        try check_conversion(hsl) { (src: HSL) -> RGB in
            src.toSRGB()
        } check: { converted, _ in
            try assertIsSameRGB(converted, rgb)
        }

        try check_conversion(hsl) { (src: HSL) -> RGB in
            rgb.space.convert(from: hsl)
        } check: { converted, _ in
            try assertIsSameRGB(converted, rgb)
        }
    }

    func test_HSL_to_XYZ() throws {
        try check_conversion(HSL(h: 64.80, s: 0.18, l: 0.18, alpha: 1.0)) { (src: HSL) -> XYZ in
            src.toXYZ()
        } check: { converted, _ in
            XCTAssertTrue(converted.x.isFinite)
            XCTAssertTrue(converted.y.isFinite)
            XCTAssertTrue(converted.z.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_HSL_to_LAB() throws {
        try check_conversion(HSL(h: 64.80, s: 0.18, l: 0.18, alpha: 1.0)) { (src: HSL) -> LAB in
            src.toLAB()
        } check: { converted, _ in
            XCTAssertTrue(converted.l.isFinite)
            XCTAssertTrue(converted.a.isFinite)
            XCTAssertTrue(converted.b.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_HSL_to_LUV() throws {
        try check_conversion(HSL(h: 64.80, s: 0.18, l: 0.18, alpha: 1.0)) { (src: HSL) -> LUV in
            src.toLUV()
        } check: { converted, _ in
            XCTAssertTrue(converted.l.isFinite)
            XCTAssertTrue(converted.u.isFinite)
            XCTAssertTrue(converted.v.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_HSL_to_HSV() throws {
        try check_conversion(HSL(h: 64, s: 0.18, l: 0.18, alpha: 1.0)) { (src: HSL) -> HSV in
            src.toHSV()
        } check: { converted, _ in
            XCTAssertEqual(converted.h, 64.0)
            XCTAssertEqual(converted.s, 0.31, accuracy: 1e-2)
            XCTAssertEqual(converted.v, 0.21, accuracy: 1e-2)
            XCTAssertEqual(converted.alpha, 1.0)
        }
    }

    func test_HSL_to_HSL() throws {
        try check_conversion(HSL(h: 64.80, s: 0.18, l: 0.18, alpha: 1.0)) { (src: HSL) -> HSL in
            src.toHSL()
        } check: { converted, src in
            XCTAssertEqual(converted.h, src.h, accuracy: 1e-5)
            XCTAssertEqual(converted.s, src.s, accuracy: 1e-5)
            XCTAssertEqual(converted.l, src.l, accuracy: 1e-5)
            XCTAssertEqual(converted.alpha, src.alpha)
        }
    }

    func test_HSL_to_CMYK() throws {
        try check_conversion(HSL(h: 64, s: 0.18, l: 0.18, alpha: 1.0)) { (src: HSL) -> CMYK in
            src.toCMYK()
        } check: { converted, _ in
            XCTAssertEqual(converted.c, 0.02, accuracy: 1e-3)
            XCTAssertEqual(converted.m, 0.0, accuracy: 1e-3)
            XCTAssertEqual(converted.y, 31.0 / 100.0, accuracy: 1e-2)
            XCTAssertEqual(converted.k, 79.0 / 100.0, accuracy: 1e-2)
            XCTAssertEqual(converted.alpha, 1.0)
        }
    }
}

extension HSLTests {

    /// Tests that we can covert through all supported color spaces without above minimal precision loss.
    func test_full_conversion() throws {
        let original = HSL(h: 64.0, s: 0.18, l: 0.18, alpha: 1.0)

        let converted = original.toSRGB().toCMYK().toXYZ().toLUV().toLAB().toHSV().toHSL()

        XCTAssertEqual(converted.h, original.h, accuracy: 1e-1)
        XCTAssertEqual(converted.s, original.s, accuracy: 1e-5)
        XCTAssertEqual(converted.l, original.l, accuracy: 1e-5)
        XCTAssertEqual(converted.alpha, original.alpha)
    }
}
