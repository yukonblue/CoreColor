//
//  LUV.swift
//  CoreColor
//
//  Created by yukonblue on 10/19/2022.
//

import Foundation

/// LUV color space.
public struct LUVColorSpace: WhitePointColorSpace {

    public typealias ColorModel = LUV

    public let whitePoint: WhitePoint

    public let name: String = "LUV"

    public let components: [ColorComponentInfo] = rectangularComponentInfo(name: "LUV")

    public func convert<T>(from srcColor: T) -> LUV where T : Color {
        srcColor.toLUV()
    }
}

/// Set of pre-defined LUV color spaces.
enum LUVColorSpaces {

    ///
    /// LUV color space calculated relative to CIE 1931 2° Standard Illuminant D65.
    ///
    static public let LUV65: LUVColorSpace = LUVColorSpace(whitePoint: Illuminant.D65)

    ///
    /// LUV color space calculated relative to CIE 1931 2° Standard Illuminant D50.
    ///
    static public let LUV50: LUVColorSpace = LUVColorSpace(whitePoint: Illuminant.D50)
}

/**
 * The CIE LUV color space, also referred to as `CIE 1976 L*u*v*`.
 *
 * ``LUV`` is calculated relative to a given white point, which defaults to CIE 1931 2° Standard Illuminant D65.
 *
 * | Component  | Description  | Range         |
 * | ---------- | ------------ | ------------- |
 * |  l         | lightness    | `[0, 100]`    |
 * |  u         |              | `[-100, 100]` |
 * |  v         |              | `[-100, 100]` |
 */
public struct LUV: Color {

    /// The 'lightness' component of the model, represented in floating-point
    /// in range of `[0.0, 100.0]`.
    public let l: Float

    /// The 'u' component of the model, represented in floating-point
    /// in range of `[-100.0, 100.0]`.
    public let u: Float

    /// The 'v' component of the model, represented in floating-point
    /// in range of `[-100.0, 100.0]`.
    public let v: Float

    public let alpha: Float

    public let space: LUVColorSpace

    public func toSRGB() -> RGB {
        l == 0.0 ? RGB(r: 0.0, g: 0.0, b: 0.0, alpha: self.alpha, space: RGBColorSpaces.sRGB) : toXYZ().toSRGB()
    }

    public func toXYZ() -> XYZ {
        let xyzSpace = XYZColorSpace(whitePoint: space.whitePoint)
        // http://www.brucelindbloom.com/Eqn_Luv_to_XYZ.html
        guard l != 0.0 else {
            return XYZ(x: 0.0, y: 0.0, z: 0.0, alpha: self.alpha, space: xyzSpace)
        }

        let wp = space.whitePoint.chromaticity
        let denominator0 = wp.X + 15.0 * wp.Y + 3.0 * wp.Z
        let u0 = 4.0 * wp.X / denominator0
        let v0 = 9.0 * wp.Y / denominator0

        let y = (l > CIE_E_times_K) ? pow(((l + 16.0) / 116.0), 3) : l / CIE_K

        let a = (52 * l / (u + 13 * l * u0) - 1) / 3
        let b = -5 * y
        let c: Float = -1.0 / 3
        let d = y * ((39 * l) / (v + 13 * l * v0) - 5)

        let x = (d - b) / (a - c)
        let z = x * a + b

        return XYZ(x: x, y: y, z: z, alpha: self.alpha, space: xyzSpace)
    }

    public static func from(color: any Color) -> Self {
        color.toLUV()
    }
}
