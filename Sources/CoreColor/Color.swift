//
//  Color.swift
//  CoreColor
//
//  Created by yukonblue on 10/14/2022.
//

/// Abstraction for concrete color models.
public protocol Color {

    /// The associated color space type related to the color model.
    associatedtype AssociatedColorSpace: ColorSpace

    /// The floating point alpha value of the color model,
    /// in range [0, 1.0].
    var alpha: Float { get }

    /// Retrieves the associated color space of the model.
    var space: AssociatedColorSpace { get }

    /// Converts to the equivalent RGB color model in sRGB color space.
    func toSRGB() -> RGB

    /// Converts to the equivalent HSL color model.
    func toHSL() -> HSL

    /// Converts to the equivalent HSV color model.
    func toHSV() -> HSV

    /// Converts to the equivalent CMYK color model.
    func toCMYK() -> CMYK

    /// Converts to the equivalent XYZ (i.e .CIE XYZ) color model.
    func toXYZ() -> XYZ

    /// Converts to the equivalent LAB (i.e. CIE 1976 `L*a*b*`) color model.
    func toLAB() -> LAB

    /// Converts to the equivalent LUV (i.e. CIE 1976 `L*u*v*`) color model.
    func toLUV() -> LUV
}

extension Color {

    public func toHSL() -> HSL {
        self.toSRGB().toHSL()
    }

    public func toHSV() -> HSV {
        self.toSRGB().toHSV()
    }

    public func toCMYK() -> CMYK {
        self.toSRGB().toCMYK()
    }

    public func toXYZ() -> XYZ {
        self.toSRGB().toXYZ()
    }

    public func toLAB() -> LAB {
        self.toXYZ().toLAB()
    }

    public func toLUV() -> LUV {
        self.toXYZ().toLUV()
    }
}

extension Color {

    /// Return `true` if all channels of this color, when converted to sRGB, lie in the range `[0, 1]`.
    var isInSRGBGamut: Bool {
        let srgb = toSRGB()
        let srgbRange: ClosedRange<Float> = (0.0...1.0)
        switch (srgb.r, srgb.g, srgb.b) {
        case (srgbRange, srgbRange, srgbRange):
            return true
        default:
            return false
        }
    }
}
