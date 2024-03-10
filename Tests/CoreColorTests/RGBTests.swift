//
//  RGBTests.swift
//  CoreColorTests
//
//  Created by yukonblue on 10/17/2022.
//

import XCTest
@testable import CoreColor

class RGBTests: ColorTestCase {

    func testInitializationFromHexString() throws {
        try checkRGB(withHex: "#000000", expected: (r: 0, g: 0, b: 0))
        try checkRGB(withHex: "#FFFFFF", expected: (r: 255, g: 255, b: 255))

        try checkRGB(withHex: "#f5deb3", expected: (r: 245, g: 222, b: 179))
        try checkRGB(withHex: "#d2b48c", expected: (r: 210, g: 180, b: 140))
        try checkRGB(withHex: "#a0522d", expected: (r: 160, g: 82, b: 45))
        try checkRGB(withHex: "#b22222", expected: (r: 178, g: 34, b: 34))

        XCTAssertNil(RGB(hex: ""))
        XCTAssertNil(RGB(hex: "000000"))
        XCTAssertNil(RGB(hex: "#00000O"))
        XCTAssertNil(RGB(hex: "#ZZZZZZ"))
        XCTAssertNil(RGB(hex: "#ABCDEFG"))
    }

    func checkRGB(withHex hex: String, expected: (r: Int, g: Int, b: Int)) throws {
        let rgb = try XCTUnwrap(RGB(hex: hex))
        XCTAssertEqual(rgb.redInt, expected.r)
        XCTAssertEqual(rgb.greenInt, expected.g)
        XCTAssertEqual(rgb.blueInt, expected.b)
    }

    /// Reference calculator:
    /// https://davengrace.com/cgi-bin/cspace.pl
    func test_sRGB_to_LinearSRGB() throws {
        try checkConversion(from: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.sRGB)) { (src: RGB) -> RGB in
            src.toLinearSRGB()
        } check: { converted, _ in
            XCTAssertEqual(converted.r, 0.0)
            XCTAssertEqual(converted.g, 0.0)
            XCTAssertEqual(converted.b, 0.0)
            XCTAssertEqual(converted.alpha, 1.0)
            XCTAssertEqual(converted.space.name, RGBColorSpaces.LinearSRGB.name)
        }

        try checkConversion(from: RGB(r: 0.18, g: 0.35, b: 0.89, alpha: 1.0, space: RGBColorSpaces.sRGB)) { (src: RGB) -> RGB in
            src.toLinearSRGB()
        } check: { converted, _ in
            XCTAssertEqual(converted.r, 0.027211785, accuracy: 1e-4)
            XCTAssertEqual(converted.g, 0.10048152, accuracy: 1e-4)
            XCTAssertEqual(converted.b, 0.7677688, accuracy: 1e-4)
            XCTAssertEqual(converted.alpha, 1.0)
            XCTAssertEqual(converted.space.name, RGBColorSpaces.LinearSRGB.name)
        }

        try checkConversion(from: RGB(r: 0.96, g: 0.83, b: 0.97, alpha: 1.0, space: RGBColorSpaces.sRGB)) { (src: RGB) -> RGB in
            src.toLinearSRGB()
        } check: { converted, _ in
            XCTAssertEqual(converted.r, 0.91140765, accuracy: 1e-4)
            XCTAssertEqual(converted.g, 0.65593076, accuracy: 1e-4)
            XCTAssertEqual(converted.b, 0.9331069, accuracy: 1e-4)
            XCTAssertEqual(converted.alpha, 1.0)
            XCTAssertEqual(converted.space.name, RGBColorSpaces.LinearSRGB.name)
        }

        try checkConversion(from: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.sRGB)) { (src: RGB) -> RGB in
            src.toLinearSRGB()
        } check: { converted, _ in
            XCTAssertEqual(converted.r, 1.0)
            XCTAssertEqual(converted.g, 1.0)
            XCTAssertEqual(converted.b, 1.0)
            XCTAssertEqual(converted.alpha, 1.0)
            XCTAssertEqual(converted.space.name, RGBColorSpaces.LinearSRGB.name)
        }
    }

    func test_sRGB_to_HSV() throws {
        try check_RGB_to_HSV(rgb: RGB(r: 0.00, g: 0.00, b: 0.00, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             hsv: HSV(h: Float.nan, s: 0.00, v: 0.00, alpha: 1.0))

        try check_RGB_to_HSV(rgb: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             hsv: HSV(h: Float.nan, s: 0.00, v: 0.18, alpha: 1.0))

        try check_RGB_to_HSV(rgb: RGB(r: 0.40, g: 0.50, b: 0.60, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             hsv: HSV(h: 210.0, s: 0.33333333, v: 0.6, alpha: 1.0))

        try check_RGB_to_HSV(rgb: RGB(r: 1.00, g: 1.00, b: 1.00, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             hsv: HSV(h: Float.nan, s: 0.00, v: 1.00, alpha: 1.0))
    }

    func test_sRGB_to_HSL() throws {
        try check_RGB_to_HSL(rgb: RGB(r: 0.00, g: 0.00, b: 0.00, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             hsl: HSL(h: Float.nan, s: 0.00, l: 0.00, alpha: 1.0))

        try check_RGB_to_HSL(rgb: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             hsl: HSL(h: Float.nan, s: 0.00, l: 0.18, alpha: 1.0))

        try check_RGB_to_HSL(rgb: RGB(r: 0.40, g: 0.50, b: 0.60, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             hsl: HSL(h: 210.0, s: 0.20, l: 0.50, alpha: 1.0))

        try check_RGB_to_HSL(rgb: RGB(r: 1.00, g: 1.00, b: 1.00, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             hsl: HSL(h: Float.nan, s: 0.00, l: 1.00, alpha: 1.0))
    }

    func test_sRGB_to_XYZ() throws {
        try check_RGB_to_XYZ(rgb: RGB(r: 0.00, g: 0.00, b: 0.00, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             xyz: XYZ(x: 0.00, y: 0.00, z: 0.00, alpha: 1.0, space: XYZColorSpaces.XYZ65))

        try check_RGB_to_XYZ(rgb: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             xyz: XYZ(x: 0.0258636, y: 0.02721178, z: 0.0296352, alpha: 1.0, space: XYZColorSpaces.XYZ65))

        try check_RGB_to_XYZ(rgb: RGB(r: 0.40, g: 0.50, b: 0.60, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             xyz: XYZ(x: 0.18882301, y: 0.20432514, z: 0.33086999, alpha: 1.0, space: XYZColorSpaces.XYZ65))

        try check_RGB_to_XYZ(rgb: RGB(r: 1.00, g: 1.00, b: 1.00, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             xyz: XYZ(x: 0.95045593, y: 1.0, z: 1.08905775, alpha: 1.0, space: XYZColorSpaces.XYZ65))
    }

    /// Reference calculator:
    /// https://davengrace.com/cgi-bin/cspace.pl
    func test_LinearSRGB_to_XYZ() throws {
        try check_RGB_to_XYZ(rgb: RGB(r: 0.00, g: 0.00, b: 0.00, alpha: 1.0, space: RGBColorSpaces.LinearSRGB),
                             xyz: XYZ(x: 0.00, y: 0.00, z: 0.00, alpha: 1.0, space: XYZColorSpaces.XYZ65))

        try check_RGB_to_XYZ(rgb: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.LinearSRGB),
                             xyz: XYZ(x: 0.1710821, y: 0.18000002, z: 0.1960304, alpha: 1.0, space: XYZColorSpaces.XYZ65))

        try check_RGB_to_XYZ(rgb: RGB(r: 0.40, g: 0.50, b: 0.60, alpha: 1.0, space: RGBColorSpaces.LinearSRGB),
                             xyz: XYZ(x: 0.45203704, y: 0.4859554, z: 0.637649, alpha: 1.0, space: XYZColorSpaces.XYZ65))

        try check_RGB_to_XYZ(rgb: RGB(r: 1.00, g: 1.00, b: 1.00, alpha: 1.0, space: RGBColorSpaces.LinearSRGB),
                             xyz: XYZ(x: 0.95045593, y: 1.0, z: 1.08905775, alpha: 1.0, space: XYZColorSpaces.XYZ65))
    }

    func test_sRGB_to_CMYK() throws {
        try check_RGB_to_CMYK(rgb: RGB(r: 0.00, g: 0.00, b: 0.00, alpha: 1.0, space: RGBColorSpaces.sRGB),
                              cmyk: CMYK(c: 0.00, m: 0.00, y: 0.00, k: 1.00, alpha: 1.00))

        try check_RGB_to_CMYK(rgb: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.sRGB),
                              cmyk: CMYK(c: 0.00, m: 0.00, y: 0.00, k: 0.82, alpha: 1.00))

        try check_RGB_to_CMYK(rgb: RGB(r: 0.40, g: 0.50, b: 0.60, alpha: 1.0, space: RGBColorSpaces.sRGB),
                              cmyk: CMYK(c: 0.33333333, m: 0.16666667, y: 0.0, k: 0.4, alpha: 1.00))

        try check_RGB_to_CMYK(rgb: RGB(r: 1.00, g: 1.00, b: 1.00, alpha: 1.0, space: RGBColorSpaces.sRGB),
                              cmyk: CMYK(c: 0.00, m: 0.00, y: 0.00, k: 0.00, alpha: 1.00))
    }

    func test_sRGB_to_LUV() throws {
        try check_RGB_to_LUV(rgb: RGB(r: 0.00, g: 0.00, b: 0.00, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             luv: LUV(l: 0.00, u: 0.00, v: 0.00, alpha: 1.00, space: LUVColorSpaces.LUV65))

        try check_RGB_to_LUV(rgb: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             luv: LUV(l: 18.89075051, u: 0.00, v: 0.00, alpha: 1.00, space: LUVColorSpaces.LUV65))

        try check_RGB_to_LUV(rgb: RGB(r: 0.40, g: 0.50, b: 0.60, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             luv: LUV(l: 52.32273694, u: -13.5765706, v: -23.98061646, alpha: 1.00, space: LUVColorSpaces.LUV65))

        try check_RGB_to_LUV(rgb: RGB(r: 1.00, g: 1.00, b: 1.00, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             luv: LUV(l: 100.00, u: 0.00, v: 0.00, alpha: 1.00, space: LUVColorSpaces.LUV65))
    }

    func test_sRGB_to_LAB() throws {
        try checkConversion(from: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.sRGB)) { (src: RGB) -> LAB in
            src.toLAB()
        } check: { converted, _ in
            XCTAssertTrue(converted.l.isFinite)
            XCTAssertTrue(converted.a.isFinite)
            XCTAssertTrue(converted.b.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_sRGB_to_sRGB() throws {
        try check_RGB_to_RGB(src: RGB(r: 0.00, g: 0.00, b: 0.00, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 0.00, g: 0.00, b: 0.00, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_RGB_to_RGB(src: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_RGB_to_RGB(src: RGB(r: 0.40, g: 0.50, b: 0.60, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 0.40, g: 0.50, b: 0.60, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_RGB_to_RGB(src: RGB(r: 0.47613, g: 0.52716, b: 0.60164, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 0.47613, g: 0.52716, b: 0.60164, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_RGB_to_RGB(src: RGB(r: 1.00, g: 1.00, b: 1.00, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 1.00, g: 1.00, b: 1.00, alpha: 1.0, space: RGBColorSpaces.sRGB))
    }

    func test_sRGB_isInSRGBGamut() throws {
        XCTAssertTrue(RGB(r: 0.00, g: 0.00, b: 0.00, alpha: 1.0, space: RGBColorSpaces.sRGB).isInSRGBGamut)
        XCTAssertTrue(RGB(r: 0.40, g: 0.50, b: 0.60, alpha: 1.0, space: RGBColorSpaces.sRGB).isInSRGBGamut)
        XCTAssertTrue(RGB(r: 1.00, g: 1.00, b: 1.00, alpha: 1.0, space: RGBColorSpaces.sRGB).isInSRGBGamut)
        XCTAssertTrue(RGB(r: 1.01, g: 1.00, b: 1.000, alpha: 1.0, space: RGBColorSpaces.sRGB).isInSRGBGamut)
        XCTAssertTrue(RGB(r: 1.00, g: 1.01, b: 1.000, alpha: 1.0, space: RGBColorSpaces.sRGB).isInSRGBGamut)
        XCTAssertTrue(RGB(r: 1.00, g: 1.00, b: 1.001, alpha: 1.0, space: RGBColorSpaces.sRGB).isInSRGBGamut)
        XCTAssertTrue(RGB(r: 2.00, g: 3.00, b: 4.00, alpha: 1.0, space: RGBColorSpaces.sRGB).isInSRGBGamut)
    }

    private func check_RGB_to_RGB(src: RGB, dst: RGB) throws {
        try checkConversion(from: src) { (src: RGB) -> RGB in
            src.toSRGB()
        } check: { converted, _ in
            try assertIsSameRGB(converted, dst)
        }

        try checkConversion(from: src) { (src: RGB) -> RGB in
            dst.space.convert(from: src)
        } check: { converted, _ in
            try assertIsSameRGB(converted, dst)
        }
    }

    private func check_RGB_to_LUV(rgb: RGB, luv: LUV) throws {
        try checkConversion(from: rgb) { (src: RGB) -> LUV in
            src.toLUV()
        } check: { converted, _ in
            try assertIsSameLUV(converted, luv)
        }

        try checkConversion(from: rgb) { (src: RGB) -> LUV in
            luv.space.convert(from: rgb)
        } check: { converted, _ in
            try assertIsSameLUV(converted, luv)
        }
    }

    private func check_RGB_to_HSV(rgb: RGB, hsv: HSV) throws {
        try checkConversion(from: rgb) { (src: RGB) -> HSV in
            src.toHSV()
        } check: { converted, _ in
            try assertIsSameHSV(converted, hsv)
        }

        try checkConversion(from: rgb) { (src: RGB) -> HSV in
            hsv.space.convert(from: rgb)
        } check: { converted, _ in
            try assertIsSameHSV(converted, hsv)
        }
    }

    private func check_RGB_to_HSL(rgb: RGB, hsl: HSL) throws {
        try checkConversion(from: rgb) { (src: RGB) -> HSL in
            src.toHSL()
        } check: { converted, _ in
            try assertIsSameHSL(converted, hsl)
        }

        try checkConversion(from: rgb) { (src: RGB) -> HSL in
            hsl.space.convert(from: rgb)
        } check: { converted, _ in
            try assertIsSameHSL(converted, hsl)
        }
    }

    private func check_RGB_to_XYZ(rgb: RGB, xyz: XYZ) throws {
        try checkConversion(from: rgb) { (src: RGB) -> XYZ in
            src.toXYZ()
        } check: { converted, _ in
            try assertIsSameXYZ(converted, xyz)
        }

        try checkConversion(from: rgb) { (src: RGB) -> XYZ in
            xyz.space.convert(from: rgb)
        } check: { converted, _ in
            try assertIsSameXYZ(converted, xyz)
        }
    }

    private func check_RGB_to_CMYK(rgb: RGB, cmyk: CMYK) throws {
        try checkConversion(from: rgb) { (src: RGB) -> CMYK in
            src.toCMYK()
        } check: { converted, _ in
            try assertIsSameCMYK(converted, cmyk)
        }

        try checkConversion(from: rgb) { (src: RGB) -> CMYK in
            cmyk.space.convert(from: rgb)
        } check: { converted, _ in
            try assertIsSameCMYK(converted, cmyk)
        }
    }
}

/// test cases from https://www.w3.org/TR/css-color-5/#colorcontrast
extension RGBTests {

    static let sRGB_f5deb3 = RGB(r: 245.0 / 255.0, g: 222.0 / 255.0, b: 179.0 / 255.0, alpha: 1.0, space: RGBColorSpaces.sRGB)
    static let sRGB_d2b48c = RGB(r: 210.0 / 255.0, g: 180.0 / 255.0, b: 140.0 / 255.0, alpha: 1.0, space: RGBColorSpaces.sRGB)
    static let sRGB_a0522d = RGB(r: 160.0 / 255.0, g: 82.0 / 255.0, b: 45.0 / 255.0, alpha: 1.0, space: RGBColorSpaces.sRGB)
    static let sRGB_b22222 = RGB(r: 178.0 / 255.0, g: 34.0 / 255.0, b: 34.0 / 255.0, alpha: 1.0, space: RGBColorSpaces.sRGB)

    func testRelativeWcagLuminance() throws {
        // #f5deb3
        try checkRelativeWcagLuminance(rgb: Self.sRGB_f5deb3, expectedWcagLuminance: 0.749)

        // d2b48c
        try checkRelativeWcagLuminance(rgb: Self.sRGB_d2b48c, expectedWcagLuminance: 0.482)

        // a0522d
        try checkRelativeWcagLuminance(rgb: Self.sRGB_a0522d, expectedWcagLuminance: 0.137)

        // b22222
        try checkRelativeWcagLuminance(rgb: Self.sRGB_b22222, expectedWcagLuminance: 0.107)
    }

    func testWcagContrastRatio() throws {
        // #f5deb3 vs. #d2b48c
        try checkWcagContrastRadio(with: Self.sRGB_f5deb3, against: Self.sRGB_d2b48c, expectedContrastRatio: 1.501)

        // #f5deb3 vs. #a0522d
        try checkWcagContrastRadio(with: Self.sRGB_f5deb3, against: Self.sRGB_a0522d, expectedContrastRatio: 4.273)

        // #f5deb3 vs. #b22222
        try checkWcagContrastRadio(with: Self.sRGB_f5deb3, against: Self.sRGB_b22222, expectedContrastRatio: 5.081)
    }

    private func checkRelativeWcagLuminance(rgb: RGB, expectedWcagLuminance: Float) throws {
        XCTAssertEqual(rgb.wcagLuminance, expectedWcagLuminance, accuracy: 1e-3)
    }

    private func checkWcagContrastRadio(with srcColor: RGB, against dstColor: RGB, expectedContrastRatio: Float) throws {
        XCTAssertEqual(srcColor.wcagContrastRatio(against: dstColor), expectedContrastRatio, accuracy: 1e-3)
    }
}

extension RGBTests {

    /// Tests that we can covert through all supported color spaces without above minimal precision loss.
    func testRoundTripConversion() throws {
        let src = Self.sRGB_f5deb3

        // Static conversion
        try checkRoundTripConversion(from: src) { original in
            original
                .toXYZ()
                .toCMYK()
                .toHSL()
                .toHSV()
                .toLUV()
                .toLAB()
                .toSRGB()
        } check: { converted, original in
            try assertIsSameRGB(converted, original)
        }

        // Dynamic conversion
        try checkRoundTripConversion(
            from: src,
            withTypes: [
                XYZ.self,
                CMYK.self,
                HSL.self,
                HSV.self,
                LUV.self,
                LAB.self,
            ]
        ) { converted, original in
            try assertIsSameRGB(converted, original)
        }
    }
}
