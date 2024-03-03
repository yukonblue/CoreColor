//
//  CMYK.swift
//  CoreColor
//
//  Created by yukonblue on 10/15/2022.
//

/**
 * A color in the CMYK (cyan, magenta, yellow, and key/black) color model.
 *
 * Conversions to and from this model use the device-independent ("naive") formulas.
 *
 * | Component  | Description | Range    |
 * | ---------- | ----------- | -------- |
 * |  c         | cyan        | `[0, 1]` |
 * |  m         | magenta     | `[0, 1]` |
 * |  y         | yellow      | `[0, 1]` |
 * |  k         | key / black | `[0, 1]` |
 */
public struct CMYK: Color {

    /// The 'cyan' component of the model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let c: Float

    /// The 'magenta' component of the model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let m: Float

    /// The 'yellow' component of the model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let y: Float

    /// The 'key' or 'black' component of the model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let k: Float

    /// The alpha component of the model, represented in floating-point
    /// in range of `[0.0, 1.0]`.
    public let alpha: Float

    public var space: CMYKColorSpace {
        Self.colorspace
    }

    public func toSRGB() -> RGB {
        let r = (1 - c) * (1 - k)
        let g = (1 - m) * (1 - k)
        let b = (1 - y) * (1 - k)
        return RGB(r: r, g: g, b: b, alpha: alpha, space: RGBColorSpaces.sRGB)
    }

    public static func from(color: any Color) -> Self {
        color.toCMYK()
    }
}

extension CMYK {

    public func toCMYK() -> CMYK {
        CMYK(c: c, m: m, y: y, k: k, alpha: alpha)
    }
}

/// CMYK color space.
public struct CMYKColorSpace: ColorSpace {

    public typealias ColorModel = CMYK

    public let name = "CMYK"

    public let components: [ColorComponentInfo] = rectangularComponentInfo(name: "CMYK")

    public func convert<T>(from srcColor: T) -> CMYK where T : Color {
        srcColor.toCMYK()
    }
}

extension CMYK {

    static let colorspace: CMYKColorSpace = CMYKColorSpace()
}
