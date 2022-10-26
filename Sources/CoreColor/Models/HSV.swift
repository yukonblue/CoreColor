//
//  HSV.swift
//  CoreColor
//
//  Created by yukonblue on 10/15/2022.
//

/**
 * A color model represented with Hue, Saturation, and Value.
 *
 * This is a cylindrical representation of the sRGB space used in [RGB].
 *
 * | Component      | Description                               | Range      |
 * | -------------- | ----------------------------------------- | ---------- |
 * | [h]            | hue, degrees, `NaN` for monochrome colors | `[0, 360)` |
 * | [s]            | saturation                                | `[0, 1]`   |
 * | [v]            | value                                     | `[0, 1]`   |
 */
public struct HSV: HueColor {

    let h: Float
    let s: Float
    let v: Float

    public func toSRGB() -> RGB {
        guard s >= 1e-7 else {
            return RGB(r: self.v, g: self.v, b: self.v, alpha: self.alpha, space: RGBColorSpaces.sRGB)
        }

        let vD = Double(v)
        let hD = Double(h).normalizeDeg / 60.0
        let sD = Double(s)

        func f(_ n: Double) -> Float {
            let kD = (n + hD).truncatingRemainder(dividingBy: 6.0)
            return Float((vD - vD * sD * min(kD, 4.0 - kD, 1.0).coerceAtLeast(minimumValue: 0.0)))
        }

        return RGB(r: f(5), g: f(3), b: f(1), alpha: self.alpha, space: RGBColorSpaces.sRGB)
    }

    public func toHSL() -> HSL {
        let vmin = max(v, 0.01)
        let l = ((2 - s) * v) / 2
        let lmin = (2 - s) * vmin
        let sl = (lmin == 2) ? 0.0 : (s * vmin) / ((lmin <= 1) ? lmin : 2 - lmin)
        return HSL(h: h, s: sl, l: l, alpha: alpha)
    }

    public let alpha: Float

    public var space: HSVColorSpace {
        Self.colorspace
    }
}

public struct HSVColorSpace: ColorSpace {

    public typealias ColorType = HSV

    public let name = "HSV"
    
    public let components: [ColorComponentInfo] = polarComponentInfo(name: "HSV")

    public func convert<T>(from srcColor: T) -> HSV where T : Color {
        srcColor.toHSV()
    }
}

extension HSV {

    static let colorspace: HSVColorSpace = HSVColorSpace()
}
