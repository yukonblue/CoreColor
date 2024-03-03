//
//  LUVTests.swift
//  CoreColorTests
//
//  Created by yukonblue on 10/19/2022.
//

import XCTest
@testable import CoreColor

class LUVTests: ColorTestCase {

    func test_LUV_to_XYZ() throws {
        try check_LUV_to_XYZ(luv: LUV(l: 0.0, u: 0.0, v: 0.0, alpha: 1.0, space: LUVColorSpaces.LUV65),
                             xyz: XYZ(x: 0.0, y: 0.0, z: 0.0, alpha: 1.0, space: XYZColorSpaces.XYZ65))

        try check_LUV_to_XYZ(luv: LUV(l: 18.00, u: 18.00, v: 18.00, alpha: 1.0, space: LUVColorSpaces.LUV65),
                             xyz: XYZ(x: 0.02854945, y: 0.02518041, z: 0.00312744, alpha: 1.0, space: XYZColorSpaces.XYZ65))

        try check_LUV_to_XYZ(luv: LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65),
                             xyz: XYZ(x: 0.12749789, y: 0.11250974, z: -0.02679452, alpha: 1.0, space: XYZColorSpaces.XYZ65))

        try check_LUV_to_XYZ(luv: LUV(l: 100.0, u: 100.0, v: 100.0, alpha: 1.0, space: LUVColorSpaces.LUV65),
                             xyz: XYZ(x: 1.13379604, y: 1.0, z: 0.12420117, alpha: 1.0, space: XYZColorSpaces.XYZ65))
    }

    func check_LUV_to_XYZ(luv: LUV, xyz: XYZ) throws {
        try checkConversion(from: luv) { (src: LUV) -> XYZ in
            src.toXYZ()
        } check: { converted, _ in
            try assertIsSameXYZ(converted, xyz)
        }

        try checkConversion(from: luv) { (src: LUV) -> XYZ in
            xyz.space.convert(from: luv)
        } check: { converted, _ in
            try assertIsSameXYZ(converted, xyz)
        }
    }

    func test_LUV_to_RGB() throws {
        let luv = LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65)

        try checkConversion(from: luv) { (src: LUV) -> RGB in
            src.toSRGB()
        } check: { rgb, _ in
            XCTAssertEqual(rgb.r, 0.54064256, accuracy: 1e-4)
            XCTAssertEqual(rgb.g, 0.32525945, accuracy: 1e-4)
            XCTAssertEqual(rgb.b, -0.5707765, accuracy: 1e-4) // TODO: This seems different from other sources.
            XCTAssertEqual(rgb.alpha, 1.0)
        }
    }

    func test_LUV_to_LAB() throws {
        let luv = LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65)

        try checkConversion(from: luv) { (src: LUV) -> LAB in
            src.toLAB()
        } check: { lab, _ in
            XCTAssertEqual(lab.l, 40.0)
            XCTAssertEqual(lab.a, 14.573768, accuracy: 1e-4)
            XCTAssertEqual(lab.b, 107.28308, accuracy: 1e-4)
            XCTAssertEqual(lab.alpha, 1.0)
        }
    }

    func test_LUV_to_HSV() throws {
        let luv = LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65)

        try checkConversion(from: luv) { (src: LUV) -> HSV in
            src.toHSV()
        } check: { hsv, _ in
            // TODO: These seem different from other sources.
            XCTAssertEqual(hsv.h, 48.372536, accuracy: 1e-4)
            XCTAssertEqual(hsv.s, 2.0557373, accuracy: 1e-4)
            XCTAssertEqual(hsv.v, 0.54064256, accuracy: 1e-4)
            XCTAssertEqual(hsv.alpha, 1.0)
        }
    }

    func test_LUV_to_HSL() throws {
        let luv = LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65)

        try checkConversion(from: luv) { (src: LUV) -> HSL in
            src.toHSL()
        } check: { hsl, _ in
            // TODO: These seem different from other sources.
            XCTAssertEqual(hsl.h, 48.372536, accuracy: 1e-4)
            XCTAssertEqual(hsl.s, -36.882607, accuracy: 1e-4)
            XCTAssertEqual(hsl.l, -0.015066981, accuracy: 1e-4)
            XCTAssertEqual(hsl.alpha, 1.0)
        }
    }

    func test_LUV_to_CMYK() throws {
        let luv = LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65)

        try checkConversion(from: luv) { (src: LUV) -> CMYK in
            src.toCMYK()
        } check: { cmyk, _ in
            // TODO: These seem different from other sources.
            XCTAssertEqual(cmyk.c, 0.0)
            XCTAssertEqual(cmyk.m, 0.39838356, accuracy: 1e-4)
            XCTAssertEqual(cmyk.y, 2.055737, accuracy: 1e-4)
            XCTAssertEqual(cmyk.k, 0.45935744, accuracy: 1e-4)
            XCTAssertEqual(cmyk.alpha, 1.0)
        }
    }

    func test_LUV_to_LUV() throws {
        let luv = LUV(l: 40.46165, u: -53.27261, v: 60.36161, alpha: 0.91617, space: LUVColorSpaces.LUV65)

        try checkConversion(from: luv) { (src: LUV) -> LUV in
            src.toLUV()
        } check: { converted, src in
            XCTAssertEqual(converted.l, src.l)
            XCTAssertEqual(converted.u, src.u)
            XCTAssertEqual(converted.v, src.v)
            XCTAssertEqual(converted.alpha, src.alpha)
            XCTAssertEqual(converted.space, src.space)
        }
    }
}

extension LUVTests {

    /// Tests that we can covert through all supported color spaces without above minimal precision loss.
    func testRoundTripConversion() throws {
        let src = LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65)

        // Static conversion
        try checkRoundTripConversion(from: src) { original in
            original
                .toSRGB()
                .toCMYK()
                .toXYZ()
                .toHSL()
                .toHSV()
                .toLAB()
                .toLUV()
        } check: { converted, original in
            try assertIsSameLUV(converted, original)
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
                LAB.self,
            ]
        ) { converted, original in
            try assertIsSameLUV(converted, original)
        }
    }
}
