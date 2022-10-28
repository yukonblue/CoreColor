//
//  XYZ.swift
//  CoreColor
//
//  Created by yukonblue on 10/14/2022.
//

import simd

/**
The CIECAM02 transform matrix for XYZ -> LMS
 
https://en.wikipedia.org/wiki/CIECAM02#CAT02
 
Matrix(
     +0.7328f, +0.4296f, -0.1624f,
     -0.7036f, +1.6975f, +0.0061f,
     +0.0030f, +0.0136f, +0.9834f,
)
 */
fileprivate let CAT02_XYZ_TO_LMS = matrix_float3x3(columns: (
    simd_float3(+0.7328, -0.7036, +0.0030),
    simd_float3(+0.4296, +1.6975, +0.0136),
    simd_float3(-0.1624, +0.0061, +0.9834)
))

fileprivate let CAT02_LMS_TO_XYZ = CAT02_XYZ_TO_LMS.inverse

/// XYZ color space abstraction.
protocol XYZColorSpaceRepresentable: WhitePointColorSpace {

    func chromaticAdaptationMatrix(for srcWp: xyY, xyzToLms: matrix_float3x3, lmsToXyz: matrix_float3x3) -> matrix_float3x3
}

extension XYZColorSpaceRepresentable {

    func chromaticAdaptationMatrix(for srcWp: xyY, xyzToLms: matrix_float3x3 = CAT02_XYZ_TO_LMS, lmsToXyz: matrix_float3x3 = CAT02_LMS_TO_XYZ) -> matrix_float3x3 {
        let dstWp = self.whitePoint.chromaticity
        
        let src = xyzToLms * simd_float3(x: srcWp.X, y: srcWp.Y, z: srcWp.Z)
        let dst = xyzToLms * simd_float3(x: dstWp.X, y: dstWp.Y, z: dstWp.Z)

        return lmsToXyz * simd_float3x3(diagonal: SIMD3<Float>(dst.x / src.x, dst.y / src.y, dst.z / src.z)) * xyzToLms
    }
}

/// Set of pre-defined XYZ color spaces.
public enum XYZColorSpaces {

    ///
    /// XYZ color space calculated relative to CIE 1931 2° Standard Illuminant D65.
    ///
    static public let XYZ65: XYZColorSpace = XYZColorSpace(whitePoint: Illuminant.D65)

    ///
    /// XYZ color space calculated relative to CIE 1931 2° Standard Illuminant D50.
    ///
    static public let XYZ50: XYZColorSpace = XYZColorSpace(whitePoint: Illuminant.D50)
}

/// XYZ color space.
public struct XYZColorSpace: XYZColorSpaceRepresentable, ColorSpace {

    public typealias ColorModel = XYZ

    public let whitePoint: WhitePoint

    public let name = "XYZ"

    public let components = rectangularComponentInfo(name: "XYZ")

    public func convert<T>(from srcColor: T) -> XYZ where T : Color {
        srcColor.toXYZ()
    }
}


///
/// The CIEXYZ color model.
///
/// ``XYZ`` is calculated relative to a given white point, which defaults to CIE 1931 2° Standard Illuminant D65.
///
/// | Component  | Range       |
/// | -------------- | -------------|
/// |  x               | `[0, 1]` |
/// |  y               | `[0, 1]` |
/// |  z               | `[0, 1]` |
public struct XYZ: Color {

    /// The 'X' component of the color model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let x: Float

    /// The 'Y' component of the color model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let y: Float

    /// The 'Z' component of the color model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let z: Float

    public let alpha: Float

    public let space: XYZColorSpace

    public func toSRGB() -> RGB {
        to(rgbSpace: RGBColorSpaces.sRGB)
    }

    func to(rgbSpace: RGBColorSpace) -> RGB {
        let xyz = adapt(toSpace: XYZColorSpace(whitePoint: rgbSpace.whitePoint))
        let xyz_v3 = simd_float3(x: xyz.x, y: xyz.y, z: xyz.z)

        let f = rgbSpace.transferFunctions.oetf

        let v = rgbSpace.matrixFromXyz * xyz_v3

        return RGB(r: f(v.x), g: f(v.y), b: f(v.z), alpha: self.alpha, space: rgbSpace)
    }

    func adapt(toSpace space: XYZColorSpace) -> XYZ {
        adaptToM(space: space, m: CAT02_XYZ_TO_LMS, mi: CAT02_LMS_TO_XYZ)
    }

    private func adaptToM(space: XYZColorSpace, m: matrix_float3x3, mi: matrix_float3x3) -> XYZ {
        let transform = self.space.chromaticAdaptationMatrix(for: self.space.whitePoint.chromaticity, xyzToLms: m, lmsToXyz: mi)

        let v = transform * simd_float3(x: self.x, y: self.y, z: self.z)

        return XYZ(x: v.x, y: v.y, z: v.z, alpha: self.alpha, space: self.space)
    }
}

extension XYZ {

    public func toLAB() -> LAB {
        func f(_ t: Float) -> Float {
            t > CIE_E ? (cbrt(t)) : ((t * CIE_K + 16) / 116)
        }

        let xyzColorSpace = self.space

        let fx = f(x / xyzColorSpace.whitePoint.chromaticity.X)
        let fy = f(y / xyzColorSpace.whitePoint.chromaticity.Y)
        let fz = f(z / xyzColorSpace.whitePoint.chromaticity.Z)

        let l = (116 * fy) - 16
        let a = 500 * (fx - fy)
        let b = 200 * (fy - fz)

        return LAB(l: l, a: a, b: b, alpha: self.alpha, space: LABColorSpace(whitePoint: xyzColorSpace.whitePoint))
    }
}

extension XYZ {

    public func toLUV() -> LUV {
        let wp = space.whitePoint.chromaticity
        let denominator = x + 15.0 * y + 3.0 * z
        let uPrime = denominator == 0.0 ? 0.0 : (4 * x) / denominator
        let vPrime = denominator == 0.0 ? 0.0 : (9 * y) / denominator

        let denominatorReference = wp.X + 15.0 * wp.Y + 3.0 * wp.Z
        let uPrimeReference = (4.0 * wp.X) / denominatorReference
        let vPrimeReference = (9.0 * wp.Y) / denominatorReference

        let yr = y / wp.Y
        let l = yr > CIE_E ? (116 * cbrt(yr) - 16) : (CIE_K * yr)

        let u = 13.0 * l * (uPrime - uPrimeReference)
        let v = 13.0 * l * (vPrime - vPrimeReference)

        return LUV(l: min(l, 100.0), u: u, v: v, alpha: self.alpha, space: LUVColorSpace(whitePoint: space.whitePoint))
    }
}
