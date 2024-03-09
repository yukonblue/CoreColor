//
//  LAB.swift
//  CoreColor
//
//  Created by yukonblue on 10/15/2022.
//

import Foundation

/// Abstraction of LAB color spaces.
protocol LABColorSpaceRepresentable: WhitePointColorSpace {

    init(whitePoint: WhitePoint)
}

/// LAB color space.
public struct LABColorSpace: LABColorSpaceRepresentable {

    public typealias ColorModel = LAB

    public let whitePoint: WhitePoint

    public let name: String = "LAB"

    public let components: [ColorComponentInfo] = rectangularComponentInfo(name: "LAB")

    public func convert<T>(from srcColor: T) -> LAB where T : Color {
        srcColor.toLAB()
    }
}

/// Set of pre-defined LAB color spaces.
public enum LABColorSpaces {

    ///
    /// LAB color space calculated relative to CIE 1931 2° Standard Illuminant D50.
    ///
    static public let LAB50: LABColorSpace = LABColorSpace(whitePoint: Illuminant.D50)

    ///
    /// LAB color space calculated relative to CIE 1931 2° Standard Illuminant D65.
    ///
    static public let LAB65: LABColorSpace = LABColorSpace(whitePoint: Illuminant.D65)
}

/**
 * CIE LAB color space, also referred to as `CIE 1976 L*a*b*`.
 *
 * The cylindrical representation of this space is LCHab.
 *
 * `LAB` is calculated relative to a given white point, which defaults to CIE 1931 2° Standard Illuminant D65.
 *
 * | Component  | Description | Range         |
 * | ---------- | ----------- | ------------- |
 * |  l         | lightness   | `[0, 100]`    |
 * |  a         | green-red   | `[-100, 100]` |
 * |  b         | blue-yellow | `[-100, 100]` |
 */
public struct LAB: Color {

    /// The 'lightness' component of the model, represented in floating-point
    /// in range of `[0.0, 100.0]`.
    public let l: Float

    /// The 'green-red' component of the model, represented in floating-point
    /// in range of `[-100.0, 100.0]`.
    public let a: Float

    /// The 'blue-yellow' component of the model, represented in floating-point
    /// in range of `[-100.0, 100.0]`.
    public let b: Float

    public let alpha: Float

    public let space: LABColorSpace

    public init(
        @Clamped(range: 0.0...100.0) l: Float,
        @Clamped(range: -100.0...100.0) a: Float,
        @Clamped(range: -100.0...100.0) b: Float,
        @Clamped(range: 0.0...1.0) alpha: Float,
        space: LABColorSpace
    ) {
        self.l = l
        self.a = a
        self.b = b
        self.alpha = alpha
        self.space = space
    }

    public func toSRGB() -> RGB {
        switch l {
        case 0.0:
            return RGB(r: 0.0, g: 0.0, b: 0.0, alpha: self.alpha, space: RGBColorSpaces.sRGB)
        default:
            return self.toXYZ().toSRGB()
        }
    }

    public func toXYZ() -> XYZ {
        // http://www.brucelindbloom.com/Eqn_Lab_to_XYZ.html
        let labColorSpace = self.space

        let xyzSpace = XYZColorSpace(whitePoint: self.space.whitePoint)

        guard self.l != 0.0 else {
            return XYZ(x: 0.0, y: 0.0, z: 0.0, alpha: self.alpha, space: xyzSpace)
        }

        let fy = (l + 16) / 116.0
        let fz = fy - b / 200.0
        let fx = a / 500.0 + fy

        let yr = l > CIE_E_times_K ? pow(fy, 3.0) : l / CIE_K
        let it = pow(fz, 3.0)
        let zr = (it > CIE_E) ? it : (116 * fz - 16) / CIE_K
        let it2 = pow(fx, 3.0)
        let xr = (it2 > CIE_E) ? it2 : (116 * fx - 16) / CIE_K

        let wp = labColorSpace.whitePoint.chromaticity

        return XYZ(x: xr * wp.X, y: yr * wp.Y, z: zr * wp.Z, alpha: self.alpha, space: xyzSpace)
    }

    public static func from(color: any Color) -> Self {
        color.toLAB()
    }
}

extension LAB {

    public func toLAB() -> LAB {
       LAB(l: l, a: a, b: b, alpha: alpha, space: space)
    }
}
