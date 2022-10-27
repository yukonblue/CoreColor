//
//  HSL.swift
//  CoreColor
//
//  Created by yukonblue on 10/15/2022.
//

protocol HueColor: Color {

    ///
    /// The hue, as degrees in the range `[0, 360)`
    ///
    var h: Float { get }
}

extension HueColor {

    func hueOr(_ n: Float) -> Float {
        guard !h.isNaN else {
            return n
        }
        return h
    }
}

/**
 * A color model represented with Hue, Saturation, and Lightness.
 *
 * This is a cylindrical representation of the sRGB space.
 *
 * | Component  | Description                               | Range      |
 * | ---------- | ----------------------------------------- | ---------- |
 * | [h]        | hue, degrees, `NaN` for monochrome colors | `[0, 360)` |
 * | [s]        | saturation                                | `[0, 1]`   |
 * | [l]        | lightness                                 | `[0, 1]`   |
 */
public struct HSL: HueColor {

    /// The 'hue' component of the model, represented in number of degrees
    /// in range of `[0.0, 360.0)`.
    public let h: Float

    /// The 'saturation' component of the model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let s: Float

    /// The 'lightness' component of the model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let l: Float

    /// The alpha component of the model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let alpha: Float

    public var space: HSLColorSpace {
        Self.colorspace
    }

    public func toSRGB() -> RGB {
        guard s >= 1e-7 else {
            return RGB(r: self.l, g: self.l, b: self.l, alpha: self.alpha, space: RGBColorSpaces.sRGB)
        }

        let hD = Double(hueOr(0)).normalizeDeg / 30.0
        let sD = Double(s)
        let lD = Double(l)

        func f(_ nD: Double) -> Float {
            let kD = (nD + hD).truncatingRemainder(dividingBy: 12.0)
            let aD = sD * min(lD, 1.0 - lD)
            return Float((lD - aD * min(kD - 3.0, 9.0 - kD, 1.0).coerceAtLeast(minimumValue: -1.0)))
        }

        return RGB(r: f(0), g: f(8), b: f(4), alpha: alpha, space: RGBColorSpaces.sRGB)
    }

    public func toHSV() -> HSV {
        var s = self.s
        var l = self.l

        var smin = s
        let lmin = max(l, 0.01)

        l *= 2
        s *= (l <= 1) ? l : 2 - l
        smin *= (lmin <= 1) ? lmin : 2 - lmin
        let v = (l + s) / 2
        let sv = (l == 0.0) ? ((2 * smin) / (lmin + smin)) : ((2 * s) / (l + s))

        return HSV(h: h, s: sv, v: v, alpha: alpha)
    }
}

/// HSL color space.
public struct HSLColorSpace: ColorSpace {

    public typealias ColorModel = HSL

    public let name = "HSL"

    public let components: [ColorComponentInfo] = polarComponentInfo(name: "HSL")

    public func convert<T>(from srcColor: T) -> HSL where T : Color {
        srcColor.toHSL()
    }
}

extension HSL {

    static let colorspace: HSLColorSpace = HSLColorSpace()
}
