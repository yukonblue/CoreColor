//
//  Color.swift
//  CoreColor
//
//  Created by yukonblue on 10/14/2022.
//

public protocol Color {

    associatedtype AssociatedColorSpace: ColorSpace

    var alpha: Float { get }

    var space: AssociatedColorSpace { get }

    func toSRGB() -> RGB

    func toHSL() -> HSL

    func toHSV() -> HSV

    func toCMYK() -> CMYK
    
    func toXYZ() -> XYZ

    func toLAB() -> LAB

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

    ///
    /// Return `true` if all channels of this color, when converted to sRGB, lie in the range `[0, 1]`
    ///
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
