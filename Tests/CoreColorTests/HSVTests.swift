//
//  HSVTests.swift
//  CoreColorTests
//
//  Created by yukonblue on 10/17/2022.
//

import XCTest
@testable import CoreColor

class HSVTests: ColorTestCase {

    func test_HSV_to_RGB() throws {
        try check_HSV_to_RGB(hsv: HSV(h: Float.nan, s: 0.00, v: 0.00, alpha: 1.0),
                             rgb: RGB(r: 0.00, g: 0.00, b: 0.00, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_HSV_to_RGB(hsv: HSV(h: 64.80, s: 0.18, v: 0.18, alpha: 1.0),
                             rgb: RGB(r: 0.177408, g: 0.18, b: 0.1476, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_HSV_to_RGB(hsv: HSV(h: 144.00, s: 0.50, v: 0.60, alpha: 1.0),
                             rgb: RGB(r: 0.3, g: 0.6, b: 0.42, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_HSV_to_RGB(hsv: HSV(h: 0.0, s: 1.00, v: 1.00, alpha: 1.0),
                             rgb: RGB(r: 1.00, g: 0.00, b: 0.00, alpha: 1.0, space: RGBColorSpaces.sRGB))
    }

    func check_HSV_to_RGB(hsv: HSV, rgb: RGB) throws {
        try checkConversion(from: hsv) { (src: HSV) -> RGB in
            src.toSRGB()
        } check: { converted, _ in
            try assertIsSameRGB(converted, rgb)
        }

        try checkConversion(from: hsv) { (src: HSV) -> RGB in
            rgb.space.convert(from: hsv)
        } check: { converted, _ in
            try assertIsSameRGB(converted, rgb)
        }
    }

    func test_HSV_to_XYZ() throws {
        try checkConversion(from: HSV(h: 144.00, s: 0.50, v: 0.60, alpha: 1.0)) { (src: HSV) -> XYZ in
            src.toXYZ()
        } check: { converted, _ in
            XCTAssertTrue(converted.x.isFinite)
            XCTAssertTrue(converted.y.isFinite)
            XCTAssertTrue(converted.z.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_HSV_to_HSL() throws {
        try checkConversion(from: HSV(h: 144.00, s: 0.50, v: 0.60, alpha: 1.0)) { (src: HSV) -> HSL in
            src.toHSL()
        } check: { converted, _ in
            XCTAssertEqual(converted.h, 144.0, accuracy: 1e-3)
            XCTAssertEqual(converted.s, 0.33, accuracy: 1e-2)
            XCTAssertEqual(converted.l, 0.45, accuracy: 1e-3)
            XCTAssertEqual(converted.alpha, 1.0)
        }
    }

    func test_HSV_to_LAB() throws {
        try checkConversion(from: HSV(h: 144.00, s: 0.50, v: 0.60, alpha: 1.0)) { (src: HSV) -> LAB in
            src.toLAB()
        } check: { converted, _ in
            XCTAssertTrue(converted.l.isFinite)
            XCTAssertTrue(converted.a.isFinite)
            XCTAssertTrue(converted.b.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_HSV_to_LUV() throws {
        try checkConversion(from: HSV(h: 144.00, s: 0.50, v: 0.60, alpha: 1.0)) { (src: HSV) -> LUV in
            src.toLUV()
        } check: { converted, _ in
            XCTAssertTrue(converted.l.isFinite)
            XCTAssertTrue(converted.u.isFinite)
            XCTAssertTrue(converted.v.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_HSV_to_CMYK() throws {
        try checkConversion(from: HSV(h: 144.00, s: 0.50, v: 0.60, alpha: 1.0)) { (src: HSV) -> CMYK in
            src.toCMYK()
        } check: { converted, _ in
            XCTAssertEqual(converted.c, 0.50)
            XCTAssertEqual(converted.m, 0.00)
            XCTAssertEqual(converted.y, 0.30)
            XCTAssertEqual(converted.k, 0.40, accuracy: 1e-2)
            XCTAssertEqual(converted.alpha, 1.0)
        }
    }

    func test_HSV_to_HSV() throws {
        try checkConversion(from: HSV(h: 144.00, s: 0.50, v: 0.60, alpha: 1.0)) { (src: HSV) -> HSV in
            src.toHSV()
        } check: { converted, src in
            XCTAssertEqual(converted.h, src.h)
            XCTAssertEqual(converted.s, src.s)
            XCTAssertEqual(converted.v, src.v)
            XCTAssertEqual(converted.alpha, src.alpha)
        }
    }
}

extension HSVTests {

    /// Tests that we can covert through all supported color spaces without above minimal precision loss.
    func test_full_conversion() throws {
        func _check(converted: HSV, original: HSV) throws {
           XCTAssertEqual(converted.h, original.h, accuracy: 1e-1)
           XCTAssertEqual(converted.s, original.s, accuracy: 1e-5)
           XCTAssertEqual(converted.v, original.v, accuracy: 1e-5)
           XCTAssertEqual(converted.alpha, original.alpha)
        }

        let src = HSV(h: 144.00, s: 0.50, v: 0.60, alpha: 1.0)

        // Static conversion
        try checkRoundTripConversion(from: src) { original in
            original
                .toSRGB()
                .toCMYK()
                .toXYZ()
                .toHSL()
                .toLUV()
                .toLAB()
                .toHSV()
        } check: { converted, original in
            try _check(converted: converted, original: original)
        }

        // Dynamic conversion
        try checkRoundTripConversion(
            from: src,
            withTypes: [
                RGB.self,
                CMYK.self,
                XYZ.self,
                HSL.self,
                LUV.self,
                LAB.self,
            ]
        ) { converted, original in
            try _check(converted: converted, original: original)
        }
    }
}
