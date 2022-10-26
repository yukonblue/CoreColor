//
//  CMYK.swift
//  CoreColor
//
//  Created by yukonblue on 10/15/2022.
//

/**
 * A color in the CMYK (cyan, magenta, yellow, and key) color model.
 *
 * Conversions to and from this model use the device-independent ("naive") formulas.
 *
 * | Component  | Description | Range    |
 * | ---------- | ----------- | -------- |
 * | [c]        | cyan        | `[0, 1]` |
 * | [m]        | magenta     | `[0, 1]` |
 * | [y]        | yellow      | `[0, 1]` |
 * | [k]        | key / black | `[0, 1]` |
 */
public struct CMYK: Color {

    let c: Float
    let m: Float
    let y: Float
    let k: Float
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
}

public struct CMYKColorSpace: ColorSpace {

    public typealias ColorType = CMYK

    public let name = "CMYK"

    public let components: [ColorComponentInfo] = rectangularComponentInfo(name: "CMYK")

    public func convert<T>(from srcColor: T) -> CMYK where T : Color {
        srcColor.toCMYK()
    }
}

extension CMYK {

    static let colorspace: CMYKColorSpace = CMYKColorSpace()
}
