//
//  ColorTestCase.swift
//  CoreColorTests
//
//  Created by yukonblue on 10/19/2022.
//

import XCTest
@testable import CoreColor

class ColorTestCase: XCTestCase {

    func checkConversion<T: Color, U: Color>(
        from src: T,
        conversion: (T) -> U,
        check: (U, T) throws -> Void
    ) throws {
        try check(conversion(src), src)
    }

    func assertIsSameRGB(_ a: RGB, _ b: RGB) throws {
        RGBEquality().checkEquals(lhs: a, rhs: b)
    }

    func assertIsSameXYZ(_ a: XYZ, _ b: XYZ) throws {
        XYZEquality().checkEquals(lhs: a, rhs: b)
    }

    func assertIsSameLUV(_ a: LUV, _ b: LUV) throws {
        LUVEquality().checkEquals(lhs: a, rhs: b)
    }

    func assertIsSameLAB(_ a: LAB, _ b: LAB) throws {
        LABEquality().checkEquals(lhs: a, rhs: b)
    }

    func assertIsSameHSV(_ a: HSV, _ b: HSV) throws {
        HSVEquality().checkEquals(lhs: a, rhs: b)
    }

    func assertIsSameHSL(_ a: HSL, _ b: HSL) throws {
        HSLEquality().checkEquals(lhs: a, rhs: b)
    }

    func assertIsSameCMYK(_ a: CMYK, _ b: CMYK) throws {
        CMYKEquality().checkEquals(lhs: a, rhs: b)
    }

    private func assertEqual(_ a: Float, _ b: Float, accuracy: Float = 1e-5) {
        switch (a.isNaN, b.isNaN) {
        case (true, true):
            break
        default:
            XCTAssertEqual(a, b, accuracy: accuracy)
        }
    }
}

extension ColorTestCase {

    func checkRoundTripConversion<T: Color>(
        from src: T,
        conversion: (T) -> T,
        check: (T, T) throws -> Void
    ) throws {
        try check(conversion(src), src)
    }

    func checkRoundTripConversion<T: Color>(
        from src: T,
        withTypes colorTypes: [any Color.Type],
        check: (T, T) throws -> Void
    ) throws {
        let intermediateResult: any Color = colorTypes.reduce(src) { result, colorType in
            result.convert(to: colorType)
        }
        let result = intermediateResult.convert(to: T.self)
        try check(result, src)
    }
}
