//
//  LABTests.swift
//  CoreColorTests
//
//  Created by yukonblue on 10/16/2022.
//

import XCTest
@testable import CoreColor

class LABTests: ColorTestCase {

    func test_LAB_to_XYZ() throws {
        try check_LAB_to_XYZ(lab: LAB(l: 0.00, a: 0.00, b: 0.00, alpha: 1.0, space: LABColorSpaces.LAB65),
                             xyz: XYZ(x: 0.0, y: 0.0, z: 0.0, alpha: 1.0, space: XYZColorSpaces.XYZ65))

        try check_LAB_to_XYZ(lab: LAB(l: 18.00, a: 18.00, b: 18.00, alpha: 1.0, space: LABColorSpaces.LAB65),
                             xyz: XYZ(x: 0.0338789, y: 0.02518041, z: 0.0091147, alpha: 1.0, space: XYZColorSpaces.XYZ65))

        try check_LAB_to_XYZ(lab: LAB(l: 40.00, a: 50.00, b: 60.00, alpha: 1.0, space: LABColorSpaces.LAB65),
                             xyz: XYZ(x: 0.18810403, y: 0.11250974, z: 0.00626937, alpha: 1.0, space: XYZColorSpaces.XYZ65))

        try check_LAB_to_XYZ(lab: LAB(l: 100.00, a: 100.00, b: 100.00, alpha: 1.0, space: LABColorSpaces.LAB65),
                             xyz: XYZ(x: 1.64238784, y: 1.0, z: 0.13613222, alpha: 1.0, space: XYZColorSpaces.XYZ65))
    }

    func check_LAB_to_XYZ(lab: LAB, xyz: XYZ) throws {
        try checkConversion(from: lab) { (src: LAB) -> XYZ in
            src.toXYZ()
        } check: { converted, _ in
            try assertIsSameXYZ(converted, xyz)
        }

        try checkConversion(from: lab) { (src: LAB) -> XYZ in
            xyz.space.convert(from: lab)
        } check: { converted, _ in
            try assertIsSameXYZ(converted, xyz)
        }
    }

    func test_LAB_to_RGB() throws {
        let lab = LAB(l: 0.00, a: 0.00, b: 0.00, alpha: 1.0, space: LABColorSpaces.LAB65)

        try checkConversion(from: lab) { (src: LAB) -> RGB in
            src.toSRGB()
        } check: { rgb, _ in
            XCTAssertEqual(rgb.r, 0.0)
            XCTAssertEqual(rgb.g, 0.0)
            XCTAssertEqual(rgb.b, 0.0)
            XCTAssertEqual(rgb.alpha, 1.0)
        }

        let lab2 = LAB(l: 56.0, a: -34.00, b: 79.00, alpha: 1.0, space: LABColorSpaces.LAB65)

        try checkConversion(from: lab2) { (src: LAB) -> RGB in
            src.convert(to: RGB.self)
        } check: { rgb, _ in
            XCTAssertEqual(rgb.r, 106.7 / 255.0, accuracy: 1e-4)
            XCTAssertEqual(rgb.g, 147.418 / 255.0, accuracy: 1e-4)
            XCTAssertEqual(rgb.b, 0.0, accuracy: 1e-4)
            XCTAssertEqual(rgb.alpha, 1.0)
        }
    }

    func test_LAB_to_LUV() throws {
        let lab = LAB(l: 56.0, a: -34.00, b: 79.00, alpha: 1.0, space: LABColorSpaces.LAB65)

        try checkConversion(from: lab) { (src: LAB) -> LUV in
            src.toLUV()
        } check: { luv, _ in
            XCTAssertEqual(luv.l, 56.0)
            XCTAssertEqual(luv.u, -20.563555, accuracy: 1e-4)
            XCTAssertEqual(luv.v, 73.01003, accuracy: 1e-4)
            XCTAssertEqual(luv.alpha, 1.0)
        }
    }

    func test_LAB_to_HSV() throws {
        let lab = LAB(l: 0.00, a: 0.00, b: 0.00, alpha: 1.0, space: LABColorSpaces.LAB65)

        try checkConversion(from: lab) { (src: LAB) -> HSV in
            src.toHSV()
        } check: { hsv, _ in
            #if false
            // TODO: Debate whether this should be reflected as NaN.
            XCTAssertTrue(hsv.h.isNaN) // Monochrome colors do not have a hue, and that is represented by `NaN`.
            #else
            XCTAssertEqual(hsv.h, 360.0)
            #endif
            XCTAssertTrue(hsv.s.isZero)
            XCTAssertTrue(hsv.v.isZero)
            XCTAssertEqual(hsv.alpha, 1.0)
        }

        let lab2 = LAB(l: 56.0, a: -34.00, b: 79.00, alpha: 1.0, space: LABColorSpaces.LAB65)

        try checkConversion(from: lab2) { (src: LAB) -> HSV in
            src.toHSV()
        } check: { hsv, _ in
            XCTAssertEqual(hsv.h, 76.56686, accuracy: 1e-4)
            XCTAssertEqual(hsv.s, 1.0, accuracy: 1e-4)
            XCTAssertEqual(hsv.v, 0.5781, accuracy: 1e-4)
            XCTAssertEqual(hsv.alpha, 1.0)
        }
    }

    func test_LAB_to_HSL() throws {
        let lab = LAB(l: 0.00, a: 0.00, b: 0.00, alpha: 1.0, space: LABColorSpaces.LAB65)

        try checkConversion(from: lab) { (src: LAB) -> HSL in
            src.toHSL()
        } check: { hsl, _ in
            #if false
            // TODO: Debate whether this should be reflected as NaN.
            XCTAssertTrue(hsl.h.isNaN) // Monochrome colors do not have a hue, and that is represented by `NaN`.
            #else
            XCTAssertEqual(hsl.h, 360.0)
            #endif
            XCTAssertTrue(hsl.s.isZero)
            XCTAssertTrue(hsl.l.isZero)
            XCTAssertEqual(hsl.alpha, 1.0)
        }

        let lab2 = LAB(l: 56.0, a: -34.00, b: 79.00, alpha: 1.0, space: LABColorSpaces.LAB65)

        try checkConversion(from: lab2) { (src: LAB) -> HSL in
            src.toHSL()
        } check: { hsl, _ in
            XCTAssertEqual(hsl.h, 76.56686, accuracy: 1e-4)
            XCTAssertEqual(hsl.s, 1.0, accuracy: 1e-4)
            XCTAssertEqual(hsl.l, 0.2890502, accuracy: 1e-4)
            XCTAssertEqual(hsl.alpha, 1.0)
        }
    }

    func test_LAB_to_CYMK() throws {
        let lab = LAB(l: 0.00, a: 0.00, b: 0.00, alpha: 1.0, space: LABColorSpaces.LAB65)

        try checkConversion(from: lab) { (src: LAB) -> CMYK in
            src.toCMYK()
        } check: { cmyk, _ in
            XCTAssertEqual(cmyk.c, 0.0)
            XCTAssertEqual(cmyk.m, 0.0)
            XCTAssertEqual(cmyk.y, 0.0)
            XCTAssertEqual(cmyk.k, 1.0)
            XCTAssertEqual(cmyk.alpha, 1.0)
        }

        let lab2 = LAB(l: 56.0, a: -34.00, b: 79.00, alpha: 1.0, space: LABColorSpaces.LAB65)

        try checkConversion(from: lab2) { (src: LAB) -> CMYK in
            src.toCMYK()
        } check: { cmyk, _ in
            XCTAssertEqual(cmyk.c, 0.27611428, accuracy: 1e-4)
            XCTAssertEqual(cmyk.m, 0.0)
            XCTAssertEqual(cmyk.y, 1.0, accuracy: 1e-4)
            XCTAssertEqual(cmyk.k, 0.42189962, accuracy: 1e-4)
            XCTAssertEqual(cmyk.alpha, 1.0)
        }
    }

    func test_LAB_to_LAB() throws {
        let lab = LAB(l: 18.371639, a: -18.16192, b: 91.4816, alpha: 1.0, space: LABColorSpaces.LAB65)

        try checkConversion(from: lab) { (src: LAB) -> LAB in
            src.toLAB()
        } check: { converted, src in
            XCTAssertEqual(converted.l, src.l)
            XCTAssertEqual(converted.a, src.a)
            XCTAssertEqual(converted.b, src.b)
            XCTAssertEqual(converted.alpha, src.alpha)
        }
    }
}

extension LABTests {

    /// Tests that we can covert through all supported color spaces without above minimal precision loss.
    func testRoundTripConversion() throws {
        func _check(converted: LAB, original: LAB) throws {
            XCTAssertEqual(converted.l, original.l, accuracy: 1e-1)
            XCTAssertEqual(converted.a, original.a, accuracy: 1e-4)
            XCTAssertEqual(converted.b, original.b, accuracy: 1e-4)
            XCTAssertEqual(converted.alpha, original.alpha)
        }

        let src = LAB(l: 18.00, a: 18.00, b: 18.00, alpha: 1.0, space: LABColorSpaces.LAB65)

        // Static conversion
        try checkRoundTripConversion(from: src) { original in
            original
                .toSRGB()
                .toCMYK()
                .toXYZ()
                .toHSL()
                .toHSV()
                .toLUV()
                .toLAB()
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
                HSV.self,
                LUV.self,
            ]
        ) { converted, original in
            try _check(converted: converted, original: original)
        }
    }
}
