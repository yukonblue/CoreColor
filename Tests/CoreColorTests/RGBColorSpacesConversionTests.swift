//
//  RGBColorSpacesConversionTests.swift
//  CoreColorTests
//
//  Created by yukonblue on 10/17/2022.
//

import XCTest
@testable import CoreColor

class RGBColorSpacesConversionTest: XCTestCase {

    func test_ADOBE_to_sRGB() throws {
        try check_RGB_to_RGB(src: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.AdobeRGB))

        try check_RGB_to_RGB(src: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 0.1942107, g: 0.1942107, b: 0.1942107, alpha: 1.0, space: RGBColorSpaces.AdobeRGB))

        try check_RGB_to_RGB(src: RGB(r: 0.25, g: 0.50, b: 0.75, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 0.34674071, g: 0.4961037, b: 0.73614257, alpha: 1.0, space: RGBColorSpaces.AdobeRGB))

        try check_RGB_to_RGB(src: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.AdobeRGB))
    }

    func test_sRGB_to_ADOBE() throws {
        try check_RGB_to_RGB(src: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.AdobeRGB),
                             dst: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_RGB_to_RGB(src: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.AdobeRGB),
                             dst: RGB(r: 0.16419367, g: 0.16419367, b: 0.16419367, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_RGB_to_RGB(src: RGB(r: 0.25, g: 0.50, b: 0.75, alpha: 1.0, space: RGBColorSpaces.AdobeRGB),
                             dst: RGB(r: -0.26405475, g: 0.5039929, b: 0.76401618, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_RGB_to_RGB(src: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.AdobeRGB),
                             dst: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.sRGB))
    }

    func test_sRGB_to_linear() throws {
        try check_RGB_to_RGB(src: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.LinearSRGB))

        try check_RGB_to_RGB(src: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 0.02721178, g: 0.02721178, b: 0.02721178, alpha: 1.0, space: RGBColorSpaces.LinearSRGB))

        try check_RGB_to_RGB(src: RGB(r: 0.25, g: 0.50, b: 0.75, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 0.05087609, g: 0.21404114, b: 0.52252155, alpha: 1.0, space: RGBColorSpaces.LinearSRGB))

        try check_RGB_to_RGB(src: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.LinearSRGB))
    }

    func test_linear_to_sRGB() throws {
        try check_RGB_to_RGB(src: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.LinearSRGB),
                             dst: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_RGB_to_RGB(src: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.LinearSRGB),
                             dst: RGB(r: 0.46135613, g: 0.46135613, b: 0.46135613, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_RGB_to_RGB(src: RGB(r: 0.25, g: 0.50, b: 0.75, alpha: 1.0, space: RGBColorSpaces.LinearSRGB),
                             dst: RGB(r: 0.53709873, g: 0.73535698, b: 0.88082502, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_RGB_to_RGB(src: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.LinearSRGB),
                             dst: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.sRGB))
    }

    func test_sRGB_to_DisplayP3() throws {
        try check_RGB_to_RGB(src: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.DisplayP3))

        try check_RGB_to_RGB(src: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.DisplayP3))

        try check_RGB_to_RGB(src: RGB(r: 0.25, g: 0.50, b: 0.75, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 0.31300491, g: 0.49410464, b: 0.7301505, alpha: 1.0, space: RGBColorSpaces.DisplayP3))

        try check_RGB_to_RGB(src: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.sRGB),
                             dst: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.DisplayP3))
    }

    func test_DisplayP3_to_sRGB() throws {
        try check_RGB_to_RGB(src: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.DisplayP3),
                             dst: RGB(r: 0.0, g: 0.0, b: 0.0, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_RGB_to_RGB(src: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.DisplayP3),
                             dst: RGB(r: 0.18, g: 0.18, b: 0.18, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_RGB_to_RGB(src: RGB(r: 0.25, g: 0.50, b: 0.75, alpha: 1.0, space: RGBColorSpaces.DisplayP3),
                             dst: RGB(r: 0.12407597, g: 0.50734577, b: 0.77112741, alpha: 1.0, space: RGBColorSpaces.sRGB))

        try check_RGB_to_RGB(src: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.DisplayP3),
                             dst: RGB(r: 1.0, g: 1.0, b: 1.0, alpha: 1.0, space: RGBColorSpaces.sRGB))
    }

    func check_RGB_to_RGB(src: RGB, dst: RGB) throws {
        try assertIsSameRGB(src.convert(toRGBColorSpace: dst.space), dst)
    }

    func assertIsSameRGB(_ a: RGB, _ b: RGB) throws {
        assertEqual(a.r, b.r, accuracy: 1e-5)
        assertEqual(a.g, b.g, accuracy: 1e-5)
        assertEqual(a.b, b.b, accuracy: 1e-5)
        assertEqual(a.alpha, b.alpha, accuracy: 1e-5)
        // TODO: Check colorspace!
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
