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
        try check_conversion(luv) { (src: LUV) -> XYZ in
            src.toXYZ()
        } check: { converted, _ in
            try assertIsSameXYZ(converted, xyz)
        }

        try check_conversion(luv) { (src: LUV) -> XYZ in
            xyz.space.convert(from: luv)
        } check: { converted, _ in
            try assertIsSameXYZ(converted, xyz)
        }
    }

    func test_LUV_to_RGB() throws {
        try check_conversion(LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65)) { (src: LUV) -> RGB in
            src.toSRGB()
        } check: { converted, _ in
            XCTAssertTrue(converted.r.isFinite)
            XCTAssertTrue(converted.g.isFinite)
            XCTAssertTrue(converted.b.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_LUV_to_LAB() throws {
        try check_conversion(LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65)) { (src: LUV) -> LAB in
            src.toLAB()
        } check: { converted, _ in
            XCTAssertTrue(converted.l.isFinite)
            XCTAssertTrue(converted.a.isFinite)
            XCTAssertTrue(converted.b.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_LUV_to_HSV() throws {
        try check_conversion(LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65)) { (src: LUV) -> HSV in
            src.toHSV()
        } check: { converted, _ in
            XCTAssertTrue(converted.h.isFinite)
            XCTAssertTrue(converted.s.isFinite)
            XCTAssertTrue(converted.v.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_LUV_to_HSL() throws {
        try check_conversion(LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65)) { (src: LUV) -> HSL in
            src.toHSL()
        } check: { converted, _ in
            XCTAssertTrue(converted.h.isFinite)
            XCTAssertTrue(converted.s.isFinite)
            XCTAssertTrue(converted.l.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_LUV_to_CMYK() throws {
        try check_conversion(LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65)) { (src: LUV) -> CMYK in
            src.toCMYK()
        } check: { converted, _ in
            XCTAssertTrue(converted.c.isFinite)
            XCTAssertTrue(converted.m.isFinite)
            XCTAssertTrue(converted.y.isFinite)
            XCTAssertTrue(converted.k.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_LUV_to_LUV() throws {
        try check_conversion(LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65)) { (src: LUV) -> LUV in
            src.toLUV()
        } check: { converted, src in
            XCTAssertEqual(converted.l, src.l, accuracy: 1e-4) // TODO: more accuracy
            XCTAssertEqual(converted.u, src.u, accuracy: 1e-4)
            XCTAssertEqual(converted.v, src.v, accuracy: 1e-4)
            XCTAssertEqual(converted.alpha, src.alpha)
        }
    }
}

extension LUVTests {

    /// Tests that we can covert through all supported color spaces without above minimal precision loss.
    func test_full_conversion() throws {
        let original = LUV(l: 40.00, u: 50.0, v: 60.0, alpha: 1.0, space: LUVColorSpaces.LUV65)

        // Static conversion
        try check_conversion(original) { (src: LUV) -> LUV in
            original
                .toSRGB()
                .toCMYK()
                .toXYZ()
                .toHSL()
                .toHSV()
                .toLAB()
                .toLUV()
        } check: { converted, src in
            try assertIsSameLUV(converted, original)
        }

        // Dynamic conversion
        try check_conversion(original) { (src: LUV) -> LUV in
            original
                .convert(to: RGB.self)
                .convert(to: CMYK.self)
                .convert(to: XYZ.self)
                .convert(to: HSL.self)
                .convert(to: HSV.self)
                .convert(to: LAB.self)
                .convert(to: LUV.self)
        } check: { converted, src in
            try assertIsSameLUV(converted, original)
        }
    }
}
