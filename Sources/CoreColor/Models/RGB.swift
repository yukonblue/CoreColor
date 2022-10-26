//
//  RGB.swift
//  CoreColor
//
//  Created by yukonblue on 10/14/2022.
//

import Foundation
import simd

/// The RGB color model, using the [sRGB][SRGB] color space by default.

public struct RGB: Color {

    let r: Float
    let g: Float
    let b: Float
    public let alpha: Float
    public let space: RGBColorSpace

    init(r: Float, g: Float, b: Float, alpha: Float, space: RGBColorSpace) {
        self.r = r
        self.g = g
        self.b = b
        self.alpha = alpha
        self.space = space
    }

    init?(hex: String, alpha: Float = 1.0, space: RGBColorSpace = RGBColorSpaces.sRGB) {
        guard let regex = try? NSRegularExpression(pattern: "^#[A-Fa-f0-9]{6}$") else {
            return nil
        }
        let matches = regex.matches(in: hex, range: NSMakeRange(0, hex.count))
        guard matches.count == 1 else {
            return nil
        }
        var rgb: UInt64 = 0
        guard Scanner(string: String(hex.dropFirst())).scanHexInt64(&rgb) else {
            return nil
        }
        self.r = Float((rgb & 0xFF0000) >> 16) / 255.0
        self.g = Float((rgb & 0x00FF00) >> 8) / 255.0
        self.b = Float(rgb & 0x0000FF) / 255.0
        self.alpha = alpha
        self.space = space
    }

    ///
    /// The red channel scaled to [0, 255].
    ///
    var redInt: Int {
        Int(r * 255)
    }

    ///
    /// The green channel scaled to [0, 255].
    ///
    var greenInt: Int {
        Int(g * 255)
    }

    ///
    /// The blue channel scaled to [0, 255]. HDR colors may exceed this range.
    ///
    var blueInt: Int {
        Int(b * 255)
    }

    ///
    /// The alpha channel scaled to [0, 255]. If the alpha is undefined, 255 will be returned.
    ///
    var alphaInt: Int {
        Int(alpha * 255)
    }

    public func toSRGB() -> RGB {
        self.convert(toRGBColorSpace: RGBColorSpaces.sRGB)
    }
}

extension RGB {

    public func toHSL() -> HSL {
        srgbHueMinMaxChroma { (h, mn, mx, chroma) -> HSL in
            let h = Float(h)
            let mn = Float(mn)
            let mx = Float(mx)
            let chroma = Float(chroma)
            let l = (mn + mx) / 2.0
            let s: Float
            if mn == mx {
                s = 0.0
            } else if l <= 0.5 {
                s = chroma / (mn + mx)
            } else {
                s = chroma / (2 - mx - mn)
            }
            return HSL(h: h, s: s, l: l, alpha: self.alpha)
        }
    }

    public func toHSV() -> HSV {
        srgbHueMinMaxChroma { (h, _, mx, chroma) -> HSV in
            let h = Float(h)
            let mx = Float(mx)
            let chroma = Float(chroma)
            let s: Float = mx == 0.0 ? 0.0 : (chroma / mx)
            let v = mx
            return HSV(h: h, s: s, v: v, alpha: self.alpha)
        }
    }

    public func toXYZ() -> XYZ {
        let f = self.space.transferFunctions.eotf

        let v = self.space.matrixToXyz * simd_float3(f(self.r), f(self.g), f(self.b))

        return XYZ(x: v.x, y: v.y, z: v.z, alpha: self.alpha, space: XYZColorSpace(whitePoint: self.space.whitePoint))
    }

    public func toCMYK() -> CMYK {
        let k = 1 - max(r, b, g)
        if k == 1.0 {
            return CMYK(c: 0, m: 0, y: 0, k: k, alpha: self.alpha)
        }
        let c = (1 - r - k) / (1 - k)
        let m = (1 - g - k) / (1 - k)
        let y = (1 - b - k) / (1 - k)
        return CMYK(c: c, m: m, y: y, k:k, alpha: self.alpha)
    }
}

extension RGB {

    ///
    /// Call [block] with the hue, min of color channels, max of color channels, and the
    /// delta between min and max.
    ///
    /// Min and max are scaled to [0, 1]
    ///
    func srgbHueMinMaxChroma<T>(_ block: (_ hue: Double, _ min: Double, _ max: Double, _ chroma: Double) -> T) -> T {
        let rD: Double = Double(self.r)
        let gD: Double = Double(self.g)
        let bD: Double = Double(self.b)

        let minD = min(rD, gD, bD)
        let maxD = max(rD, gD, bD)
        let chroma = maxD - minD

        let h: Double = {
            if chroma < 1e-7 {
                return Double.nan
            } else if rD == maxD {
                return (gD - bD) / chroma
            } else if gD == maxD {
                return 2 + (bD - rD) / chroma
            } else if bD == maxD {
                return 4 + (rD - gD) / chroma
            } else {
                return 0.0
            }
        }() * 60

        return block(h.normalizeDeg, minD, maxD, chroma)
    }
}

extension RGB {

    func convert(toRGBColorSpace dstRGBColorSpace: RGBColorSpace) -> RGB {
        let srcRGBColorSpace = self.space

        let f = RGBColorSpaces.sRGB.transferFunctions
        if srcRGBColorSpace == dstRGBColorSpace {
            return self
        } else if srcRGBColorSpace == RGBColorSpaces.sRGB && dstRGBColorSpace == RGBColorSpaces.LinearSRGB {
            return RGB(r: f.eotf(r),g: f.eotf(g), b: f.eotf(b), alpha: self.alpha, space: dstRGBColorSpace)
        } else if srcRGBColorSpace == RGBColorSpaces.LinearSRGB && dstRGBColorSpace == RGBColorSpaces.sRGB {
            return RGB(r: f.oetf(r), g: f.oetf(g), b: f.oetf(b), alpha: self.alpha, space: dstRGBColorSpace)
        } else {
            return self.toXYZ().to(rgbSpace: dstRGBColorSpace)
        }
    }
}
