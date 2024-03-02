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
        try checkConversion(from: LAB(l: 0.00, a: 0.00, b: 0.00, alpha: 1.0, space: LABColorSpaces.LAB65)) { (src: LAB) -> RGB in
            src.toSRGB()
        } check: { converted, _ in
            XCTAssertTrue(converted.r.isFinite)
            XCTAssertTrue(converted.g.isFinite)
            XCTAssertTrue(converted.b.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_LAB_to_LUV() throws {
        try checkConversion(from: LAB(l: 0.00, a: 0.00, b: 0.00, alpha: 1.0, space: LABColorSpaces.LAB65)) { (src: LAB) -> LUV in
            src.toLUV()
        } check: { converted, _ in
            XCTAssertTrue(converted.l.isFinite)
            XCTAssertTrue(converted.u.isFinite)
            XCTAssertTrue(converted.v.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_LAB_to_HSV() throws {
        try checkConversion(from: LAB(l: 0.00, a: 0.00, b: 0.00, alpha: 1.0, space: LABColorSpaces.LAB65)) { (src: LAB) -> HSV in
            src.toHSV()
        } check: { converted, _ in
//            XCTAssertTrue(converted.h.isFinite) // TODO: make this work
            XCTAssertTrue(converted.s.isFinite)
            XCTAssertTrue(converted.v.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_LAB_to_HSL() throws {
        try checkConversion(from: LAB(l: 0.00, a: 0.00, b: 0.00, alpha: 1.0, space: LABColorSpaces.LAB65)) { (src: LAB) -> HSL in
            src.toHSL()
        } check: { converted, _ in
//            XCTAssertTrue(converted.h.isFinite) // TODO: make this work
            XCTAssertTrue(converted.s.isFinite)
            XCTAssertTrue(converted.l.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_LAB_to_CYMK() throws {
        try checkConversion(from: LAB(l: 0.00, a: 0.00, b: 0.00, alpha: 1.0, space: LABColorSpaces.LAB65)) { (src: LAB) -> CMYK in
            src.toCMYK()
        } check: { converted, _ in
            XCTAssertTrue(converted.c.isFinite)
            XCTAssertTrue(converted.m.isFinite)
            XCTAssertTrue(converted.y.isFinite)
            XCTAssertTrue(converted.k.isFinite)
            XCTAssertTrue(converted.alpha.isFinite)
        }
    }

    func test_LAB_to_LAB() throws {
        try checkConversion(from: LAB(l: 18.00, a: 18.00, b: 18.00, alpha: 1.0, space: LABColorSpaces.LAB65)) { (src: LAB) -> LAB in
            src.toLAB()
        } check: { converted, src in
            XCTAssertEqual(converted.l, src.l, accuracy: 1e-5)
            XCTAssertEqual(converted.a, src.a, accuracy: 1e-5)
            XCTAssertEqual(converted.b, src.b, accuracy: 1e-5)
            XCTAssertEqual(converted.alpha, src.alpha, accuracy: 1e-5)
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
