//
//  RGBColorSpaceTests.swift
//  CoreColorTests
//
//  Created by yukonblue on 10/21/2022.
//

import XCTest
@testable import CoreColor

class RGBColorSpaceTests: XCTestCase {

    func testRGBColorSpaceEquality() throws {
        let name = "Fake"
        let whitePoint = Illuminant.D50
        let transferFunctions = SRGBTransferFunctions()
        let r = xyY(x: 0.0, y: 0.1)
        let g = xyY(x: 0.1, y: 0.2)
        let b = xyY(x: 0.2, y: 0.3)

        let colorspace1 = RGBColorSpace(name: name,
                                        whitePoint: whitePoint,
                                        transferFunctions: transferFunctions,
                                        r: r,
                                        g: g,
                                        b: b)

        XCTAssertEqual(colorspace1, colorspace1)

        // Create an identical colorspace with the exact same parameters.
        let colorspace2 = RGBColorSpace(name: name,
                                        whitePoint: whitePoint,
                                        transferFunctions: transferFunctions,
                                        r: r,
                                        g: g,
                                        b: b)

        // Tests the two colorspaces evaluate to being equal.
        XCTAssertEqual(colorspace2, colorspace1)

        // Create another colorspace with slight variation in parameter.
        let colorspace3 = RGBColorSpace(name: name,
                                        whitePoint: whitePoint,
                                        transferFunctions: transferFunctions,
                                        r: r,
                                        g: xyY(x: 5.0, y: 5.0),
                                        b: b)

        // Tests the new colorspace does not evaluate to being equal with any of the other two.
        XCTAssertNotEqual(colorspace3, colorspace1)
        XCTAssertNotEqual(colorspace3, colorspace2)
    }
}
