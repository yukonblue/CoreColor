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
        try checkConversion(from: hsl) { (src: HSL) -> RGB in
            src.toSRGB()
        } check: { converted, _ in
            try assertIsSameRGB(converted, rgb)
        }

        try checkConversion(from: hsl) { (src: HSL) -> RGB in
            src.convert(to: RGB.self)
        } check: { converted, _ in
            try assertIsSameRGB(converted, rgb)
        }

        try checkConversion(from: hsl) { (src: HSL) -> RGB in
            rgb.space.convert(from: hsl)
        } check: { converted, _ in
            try assertIsSameRGB(converted, rgb)
        }
    }

    func test_HSL_to_XYZ() throws {
        let hsl = HSL(h: 64.80, s: 0.18, l: 0.18, alpha: 1.0)

        try checkConversion(from: hsl) { (src: HSL) -> XYZ in
            src.toXYZ()
        } check: { xyz, _ in
            XCTAssertEqual(xyz.x, 0.03130435, accuracy: 1e-4)
            XCTAssertEqual(xyz.y, 0.035436176, accuracy: 1e-4)
            XCTAssertEqual(xyz.z, 0.023223856, accuracy: 1e-4)
            XCTAssertEqual(xyz.alpha, 1.0)
        }
    }

    func test_HSL_to_LAB() throws {
        let hsl = HSL(h: 64.80, s: 0.18, l: 0.18, alpha: 1.0)

        try checkConversion(from: hsl) { (src: HSL) -> LAB in
            src.toLAB()
        } check: { lab, _ in
            XCTAssertEqual(lab.l, 22.101345, accuracy: 1e-4)
            XCTAssertEqual(lab.a, -3.9567351, accuracy: 1e-4)
            XCTAssertEqual(lab.b, 10.23053, accuracy: 1e-4)
            XCTAssertEqual(lab.alpha, 1.0)
        }
    }

    func test_HSL_to_LUV() throws {
        let hsl = HSL(h: 64.80, s: 0.18, l: 0.18, alpha: 1.0)

        try checkConversion(from: hsl) { (src: HSL) -> LUV in
            src.toLUV()
        } check: { luv, _ in
            XCTAssertEqual(luv.l, 22.101345, accuracy: 1e-5)
            XCTAssertEqual(luv.u, 0.039165918, accuracy: 1e-4)
            XCTAssertEqual(luv.v, 10.31336, accuracy: 1e-4)
            XCTAssertEqual(luv.alpha, 1.0)
        }

        try checkConversion(from: hsl) { (src: HSL) -> LUV in
            src.convert(to: LUV.self)
        } check: { luv, _ in
            XCTAssertEqual(luv.l, 22.101345, accuracy: 1e-5)
            XCTAssertEqual(luv.u, 0.039165918, accuracy: 1e-4)
            XCTAssertEqual(luv.v, 10.31336, accuracy: 1e-4)
            XCTAssertEqual(luv.alpha, 1.0)
        }
    }

    func test_HSL_to_HSV() throws {
        let hsl = HSL(h: 64, s: 0.18, l: 0.18, alpha: 1.0)

        try checkConversion(from: hsl) { (src: HSL) -> HSV in
            src.toHSV()
        } check: { hsv, _ in
            XCTAssertEqual(hsv.h, 64.0)
            XCTAssertEqual(hsv.s, 0.31, accuracy: 1e-2)
            XCTAssertEqual(hsv.v, 0.21, accuracy: 1e-2)
            XCTAssertEqual(hsv.alpha, 1.0)
        }

        try checkConversion(from: hsl) { (src: HSL) -> HSV in
            src.convert(to: HSV.self)
        } check: { hsv, _ in
            XCTAssertEqual(hsv.h, 64.0)
            XCTAssertEqual(hsv.s, 0.31, accuracy: 1e-2)
            XCTAssertEqual(hsv.v, 0.21, accuracy: 1e-2)
            XCTAssertEqual(hsv.alpha, 1.0)
        }
    }

    func test_HSL_to_HSL() throws {
        let hsl = HSL(h: 64.8046, s: 0.5318, l: 0.9173, alpha: 0.274)

        try checkConversion(from: hsl) { (src: HSL) -> HSL in
            src.toHSL()
        } check: { converted, src in
            XCTAssertEqual(converted.h, src.h)
            XCTAssertEqual(converted.s, src.s)
            XCTAssertEqual(converted.l, src.l)
            XCTAssertEqual(converted.alpha, src.alpha)
        }
    }

    func test_HSL_to_CMYK() throws {
        let hsl = HSL(h: 64, s: 0.18, l: 0.18, alpha: 1.0)

        try checkConversion(from: hsl) { (src: HSL) -> CMYK in
            src.toCMYK()
        } check: { cmyk, _ in
            XCTAssertEqual(cmyk.c, 0.02, accuracy: 1e-3)
            XCTAssertEqual(cmyk.m, 0.0, accuracy: 1e-3)
            XCTAssertEqual(cmyk.y, 31.0 / 100.0, accuracy: 1e-2)
            XCTAssertEqual(cmyk.k, 79.0 / 100.0, accuracy: 1e-2)
            XCTAssertEqual(cmyk.alpha, 1.0)
        }
    }
}

extension HSLTests {

    /// Tests that we can covert through all supported color spaces without above minimal precision loss.
    func testRoundTripConversion() throws {
        func _check(converted: HSL, original: HSL) throws {
            XCTAssertEqual(converted.h, original.h, accuracy: 1e-1)
            XCTAssertEqual(converted.s, original.s, accuracy: 1e-5)
            XCTAssertEqual(converted.l, original.l, accuracy: 1e-5)
            XCTAssertEqual(converted.alpha, original.alpha)
        }

        let src = HSL(h: 64.0, s: 0.18, l: 0.18, alpha: 1.0)

        // Static conversion
        try checkRoundTripConversion(from: src) { original in
            original
                .toSRGB()
                .toCMYK()
                .toXYZ()
                .toLUV()
                .toLAB()
                .toHSV()
                .toHSL()
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
                LUV.self,
                LAB.self,
                HSV.self,
            ]
        ) { converted, original in
            try _check(converted: converted, original: original)
        }
    }
}
