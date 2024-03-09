//
//  CMYKTests.swift
//  CoreColorTests
//
//  Created by yukonblue on 10/16/2022.
//

import XCTest
@testable import CoreColor

class CMYKTests: ColorTestCase {

    func test_CMYK_to_RGB() throws {
        try check_CMYK_to_RGB(cmyk: CMYK(c: 0.00, m: 0.00, y: 0.00, k: 0.00, alpha: 1.0),
                              rgb: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_CMYK_to_RGB(cmyk: CMYK(c: 0.18, m: 0.18, y: 0.18, k: 0.18, alpha: 1.0),
                              rgb: RGB(r: 0.6724, g: 0.6724, b: 0.6724, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_CMYK_to_RGB(cmyk: CMYK(c: 0.40, m: 0.50, y: 0.60, k: 0.70, alpha: 1.0),
                              rgb: RGB(r: 0.18, g: 0.15, b: 0.12, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_CMYK_to_RGB(cmyk: CMYK(c: 1.00, m: 1.00, y: 1.00, k: 1.00, alpha: 1.0),
                              rgb: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_CMYK_to_RGB(cmyk: CMYK(c: 0.00, m: 16.0 / 100.0, y: 100.00 / 100.0, k: 0.00, alpha: 1.0),
                              rgb: RGB(r: 1.0, g: 214.0 / 255.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.sRGB))
    }

    func check_CMYK_to_RGB(cmyk: CMYK, rgb: RGB) throws {
        try checkConversion(from: cmyk) { (src: CMYK) -> RGB in
            src.toSRGB()
        } check: { converted, _ in
            try assertIsSameRGB(converted, rgb)
        }

        try checkConversion(from: cmyk) { (src: CMYK) -> RGB in
            src.convert(to: RGB.self)
        } check: { converted, _ in
            try assertIsSameRGB(converted, rgb)
        }
    }

    func test_CMYK_to_XYZ() throws {
        let cmyk = CMYK(c: 0.0, m: 0.0, y: 0.0, k: 0.0, alpha: 1.0)

        try checkConversion(from: cmyk) { (src: CMYK) -> XYZ in
            src.toXYZ()
        } check: { xyz, _ in
            XCTAssertEqual(xyz.x, 0.9504561, accuracy: 1e-4)
            XCTAssertEqual(xyz.y, 1.0000001, accuracy: 1e-4)
            XCTAssertEqual(xyz.z, 1.0890577, accuracy: 1e-4)
            XCTAssertEqual(xyz.alpha, 1.0)
        }
    }

    func test_CMYK_to_LAB() throws {
        let cmyk = CMYK(c: 0.0, m: 0.0, y: 0.0, k: 0.0, alpha: 1.0)

        try checkConversion(from: cmyk) { (src: CMYK) -> LAB in
            src.toLAB()
        } check: { lab, _ in
            XCTAssertEqual(lab.l, 100.0)
            XCTAssertEqual(lab.a, 0.0)
            XCTAssertEqual(lab.b, 0.0)
            XCTAssertEqual(lab.alpha, 1.0)
        }
    }

    func test_CMYK_to_LUV() throws {
        let cmyk = CMYK(c: 0.0, m: 0.0, y: 0.0, k: 0.0, alpha: 1.0)

        try checkConversion(from: cmyk) { (src: CMYK) -> LUV in
            src.toLUV()
        } check: { luv, _ in
            XCTAssertEqual(luv.l, 100.0)
            XCTAssertEqual(luv.u, 0.0)
            XCTAssertEqual(luv.v, 0.0)
            XCTAssertEqual(luv.alpha, 1.0)
        }
    }

    func test_CMYK_to_HSV() throws {
        let cmyk = CMYK(c: 0.0, m: 16.0 / 100.0, y: 100.0 / 100.0, k: 0.0, alpha: 1.0)

        try checkConversion(from: cmyk) { (src: CMYK) -> HSV in
            src.toHSV()
        } check: { hsv, _ in
            XCTAssertEqual(hsv.h, 50.4)
            XCTAssertEqual(hsv.s, 100.0 / 100.0)
            XCTAssertEqual(hsv.v, 100.0 / 100.0)
            XCTAssertEqual(hsv.alpha, 1.0)
        }
    }

    func test_CMYK_to_HSL() throws {
        let cmyk = CMYK(c: 0.0, m: 0.0, y: 0.0, k: 0.0, alpha: 1.0)

        try checkConversion(from: cmyk) { (src: CMYK) -> HSL in
            src.toHSL()
        } check: { hsl, _ in
            #if false
            // TODO: Debate whether this should be reflected as NaN.
            XCTAssertTrue(hsl.h.isNaN) // Monochrome colors do not have a hue, and that is represented by `NaN`.
            #else
            XCTAssertEqual(hsl.h, 360.0)
            #endif
            XCTAssertEqual(hsl.s, 0.0)
            XCTAssertEqual(hsl.l, 1.00)
            XCTAssertEqual(hsl.alpha, 1.00)
        }

        let cmyk2 = CMYK(c: 0.0, m: 16.0 / 100.0, y: 100.0 / 100.0, k: 0.0, alpha: 1.0)

        try checkConversion(from: cmyk2) { (src: CMYK) -> HSL in
            src.toHSL()
        } check: { hsl, _ in
            XCTAssertEqual(hsl.h, 50.4)
            XCTAssertEqual(hsl.s, 100.0 / 100.0)
            XCTAssertEqual(hsl.l, 50.0 / 100.0)
            XCTAssertEqual(hsl.alpha, 1.00)
        }
    }

    func test_CMYK_to_CMYK() throws {
        let cmyk = CMYK(c: 0.174, m: 0.9561, y: 0.3615, k: 0.2946, alpha: 0.16491)

        try checkConversion(from: cmyk) { (src: CMYK) -> CMYK in
            src.toCMYK()
        } check: { converted, src in
            CMYKEquality().checkEqualsExact(lhs: converted, rhs: src)
        }
    }
}

extension CMYKTests {

    /// Tests that we can covert through all supported color spaces without above minimal precision loss.
    func testRoundTripConversion() throws {
        let src = CMYK(c: 0.0, m: 16.0 / 100.0, y: 100.0 / 100.0, k: 0.0, alpha: 1.0)

        // Static conversion
        try checkRoundTripConversion(from: src) { original in
            original
                .toSRGB()
                .toXYZ()
                .toHSL()
                .toHSV()
                .toLUV()
                .toLAB()
                .toCMYK()
        } check: { converted, original in
            try assertIsSameCMYK(converted, original)
        }

        // Dynamic conversion
        try checkRoundTripConversion(
            from: src,
            withTypes: [
                RGB.self,
                XYZ.self,
                HSL.self,
                HSV.self,
                LUV.self,
                LAB.self
            ]
        ) { converted, original in
            try assertIsSameCMYK(converted, original)
        }
    }
}
