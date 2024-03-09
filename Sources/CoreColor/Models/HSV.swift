//
//  HSV.swift
//  CoreColor
//
//  Created by yukonblue on 10/15/2022.
//

/**
 * A color model represented with Hue, Saturation, and Value.
 *
 * This is a cylindrical representation of the sRGB space.
 *
 * | Component      | Description                               | Range      |
 * | -------------- | ----------------------------------------- | ---------- |
 * | [h]            | hue, degrees, `NaN` for monochrome colors | `[0, 360)` |
 * | [s]            | saturation                                | `[0, 1]`   |
 * | [v]            | value                                     | `[0, 1]`   |
 */
public struct HSV: HueColor {

    /// The 'hue' component of the model, represented in number of degrees
    /// in range of `[0.0, 360.0)`.
    ///
    /// Note: Monochrome colors do not have a hue, and that is represented by `NaN`.
    public let h: Float

    /// The 'saturation' component of the model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let s: Float

    /// The 'value' component of the model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let v: Float

    /// The alpha component of the model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let alpha: Float

    public init(
        @Clamped(range: 0.0...360.0) h: Float,
        @Clamped(range: 0.0...1.0) s: Float,
        @Clamped(range: 0.0...1.0) v: Float,
        @Clamped(range: 0.0...1.0) alpha: Float
    ) {
        self.h = h
        self.s = s
        self.v = v
        self.alpha = alpha
    }

    public var space: HSVColorSpace {
        Self.colorspace
    }

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

    public static func from(color: any Color) -> Self {
        color.toHSV()
    }
}

extension HSV {

    public func toHSV() -> HSV {
        HSV(h: h, s: s, v: v, alpha: alpha)
    }
}

/// HSV color space.
public struct HSVColorSpace: ColorSpace {

    public typealias ColorModel = HSV

    public let name = "HSV"
    
    public let components: [ColorComponentInfo] = polarComponentInfo(name: "HSV")

    public func convert<T>(from srcColor: T) -> HSV where T : Color {
        srcColor.toHSV()
    }
}

extension HSV {

    static let colorspace: HSVColorSpace = HSVColorSpace()
}
