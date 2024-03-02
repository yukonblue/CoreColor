//
//  XYZTests.swift
//  CoreColorTests
//
//  Created by yukonblue on 10/17/2022.
//

import XCTest
@testable import CoreColor

class XYZTests: ColorTestCase {

    func test_XYZ_to_SRGB() throws {
        try check_XYZ_to_RGB(xyz: XYZ(x: 0.00, y: 0.00, z: 0.00, alpha: 1.0, space: XYZColorSpaces.XYZ65),
                             rgb: RGB(r: 0.00, g: 0.00, b: 0.00, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_XYZ_to_RGB(xyz: XYZ(x: 0.18, y: 0.18, z: 0.18, alpha: 1.0, space: XYZColorSpaces.XYZ65),
                             rgb: RGB(r: 0.50307213, g: 0.45005582, b: 0.44114606, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_XYZ_to_RGB(xyz: XYZ(x: 0.40, y: 0.50, z: 0.60, alpha: 1.0, space: XYZColorSpaces.XYZ65),
                             rgb: RGB(r: 0.51535521, g: 0.78288241, b: 0.77013935, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_XYZ_to_RGB(xyz: XYZ(x: 1.0, y: 1.00, z: 1.00, alpha: 1.0, space: XYZColorSpaces.XYZ65),
                             rgb: RGB(r: 1.08523261, g: 0.97691161, b: 0.95870753, alpha: 1.0, space: RGBColorSpaces.sRGB))
    }

    func test_XYZ_to_LAB() throws {
        try check_XYZ_to_LAB(xyz: XYZ(x: 0.25, y: 0.50, z: 0.75, alpha: 1.0, space: XYZColorSpaces.XYZ50),
                             lab: LAB(l: 76.06926101, a: -78.02949711, b: -34.99756832, alpha: 1.0, space: LABColorSpaces.LAB50))
    }

    func test_XYZ_to_LUV() throws {
        try check_XYZ_to_LUV(xyz: XYZ(x: 0.00, y: 0.00, z: 0.00, alpha: 1.0, space: XYZColorSpaces.XYZ65),
                             luv: LUV(l: 0.00, u: 0.00, v: 0.00, alpha: 1.0, space: LUVColorSpaces.LUV65))

        try check_XYZ_to_LUV(xyz: XYZ(x: 0.18, y: 0.18, z: 0.18, alpha: 1.0, space: XYZColorSpaces.XYZ65),
                             luv: LUV(l: 49.49610761, u: 8.16943249, v: 3.4516013, alpha: 1.0, space: LUVColorSpaces.LUV65))

        try check_XYZ_to_LUV(xyz: XYZ(x: 0.40, y: 0.50, z: 0.60, alpha: 1.0, space: XYZColorSpaces.XYZ65),
                             luv: LUV(l: 76.06926101, u: -32.51658072, v: -4.35360349, alpha: 1.0, space: LUVColorSpaces.LUV65))

        try check_XYZ_to_LUV(xyz: XYZ(x: 1.00, y: 1.00, z: 1.00, alpha: 1.0, space: XYZColorSpaces.XYZ65),
                             luv: LUV(l: 100.0, u: 16.50520189, v: 6.97348026, alpha: 1.0, space: LUVColorSpaces.LUV65))

        // XYZ50 -> LUV50
        try check_XYZ_to_LUV(xyz: XYZ(x: 0.25, y: 0.5, z: 0.75, alpha: 1.0, space: XYZColorSpaces.XYZ50),
                             luv: LUV(l: 76.06926101, u: -107.96735088, v: -37.65708044, alpha: 1.0, space: LUVColorSpaces.LUV50))
    }

    func test_XYZ_to_HSV() throws {
        try checkConversion(from: XYZ(x: 0.40, y: 0.50, z: 0.60, alpha: 1.0, space: XYZColorSpaces.XYZ65)) { (src: XYZ) -> HSV in
            src.toHSV()
        } check: { converted, _ in
            XCTAssertTrue(converted.h.isFinite)
            XCTAssertTrue(converted.s.isFinite)
            XCTAssertTrue(converted.v.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_XYZ_to_HSL() throws {
        try checkConversion(from: XYZ(x: 0.40, y: 0.50, z: 0.60, alpha: 1.0, space: XYZColorSpaces.XYZ65)) { (src: XYZ) -> HSL in
            src.toHSL()
        } check: { converted, _ in
            XCTAssertTrue(converted.h.isFinite)
            XCTAssertTrue(converted.s.isFinite)
            XCTAssertTrue(converted.l.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_XYZ_to_XYZ() throws {
        try checkConversion(from: XYZ(x: 0.40, y: 0.50, z: 0.60, alpha: 1.0, space: XYZColorSpaces.XYZ65)) { (src: XYZ) -> XYZ in
            src.toXYZ()
        } check: { converted, src in
            try assertIsSameXYZ(converted, src)
        }
    }

    func test_XYZ_to_CMYK() throws {
        try checkConversion(from: XYZ(x: 0.40, y: 0.50, z: 0.60, alpha: 1.0, space: XYZColorSpaces.XYZ65)) { (src: XYZ) -> CMYK in
            src.toCMYK()
        } check: { converted, _ in
            XCTAssertTrue(converted.c.isFinite)
            XCTAssertTrue(converted.m.isFinite)
            XCTAssertTrue(converted.y.isFinite)
            XCTAssertTrue(converted.k.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func check_XYZ_to_LUV(xyz: XYZ, luv: LUV) throws {
        try checkConversion(from: xyz) { (src: XYZ) -> LUV in
            src.toLUV()
        } check: { converted, _ in
            try assertIsSameLUV(converted, luv)
        }

        try checkConversion(from: xyz) { (src: XYZ) -> LUV in
            luv.space.convert(from: xyz)
        } check: { converted, _ in
            try assertIsSameLUV(converted, luv)
        }
    }

    func check_XYZ_to_RGB(xyz: XYZ, rgb: RGB) throws {
        try checkConversion(from: xyz) { (src: XYZ) -> RGB in
            src.toSRGB()
        } check: { converted, _ in
            try assertIsSameRGB(converted, rgb)
        }

        try checkConversion(from: xyz) { (src: XYZ) -> RGB in
            rgb.space.convert(from: xyz)
        } check: { converted, _ in
            try assertIsSameRGB(converted, rgb)
        }
    }

    func check_XYZ_to_LAB(xyz: XYZ, lab: LAB) throws {
        try checkConversion(from: xyz) { (src: XYZ) -> LAB in
            src.toLAB()
        } check: { converted, _ in
            try assertIsSameLAB(converted, lab)
        }

        try checkConversion(from: xyz) { (src: XYZ) -> LAB in
            lab.space.convert(from: xyz)
        } check: { converted, _ in
            try assertIsSameLAB(converted, lab)
        }
    }
}

extension XYZTests {

    /// Tests that we can covert through all supported color spaces without above minimal precision loss.
    func test_full_conversion() throws {
        let original = XYZ(x: 0.40, y: 0.50, z: 0.60, alpha: 1.0, space: XYZColorSpaces.XYZ65)

        // Static conversion
        try checkConversion(from: original) { (src: XYZ) -> XYZ in
            original
                .toSRGB()
                .toCMYK()
                .toHSL()
                .toHSV()
                .toLUV()
                .toLAB()
                .toXYZ()
        } check: { converted, original in
            try assertIsSameXYZ(converted, original)
        }

        // Dynamic conversion
        try checkConversion(from: original) { (src: XYZ) -> XYZ in
            original
                .convert(to: RGB.self)
                .convert(to: CMYK.self)
                .convert(to: HSL.self)
                .convert(to: HSV.self)
                .convert(to: LUV.self)
                .convert(to: LAB.self)
                .convert(to: XYZ.self)
        } check: { converted, original in
            try assertIsSameXYZ(converted, original)
        }
    }
}
