//
//  Color+Constrast.swift
//  CoreColor
//
//  Created by yukonblue on 10/25/2022.
//

public extension Color {

    ///
    /// Calculate the relative luminance of this color according to the
    /// [Web Content Accessibility Guidelines](https://www.w3.org/TR/WCAG21/#dfn-relative-luminance)
    ///
    /// Returns the relative luminance of this color, which ranges from 0 to 1 for in-gamut sRGB colors.
    ///
    var wcagLuminance: Float {
        let linearSRGBColor = RGBColorSpaces.LinearSRGB.convert(from: self)
        return (0.2126 * linearSRGBColor.r + 0.7152 * linearSRGBColor.g + 0.0722 * linearSRGBColor.b)
    }

    ///
    /// Calculate the contrast ratio of this color with `other` according to the
    /// [Web Content Accessibility Guidelines](https://www.w3.org/TR/WCAG21/#dfn-contrast-ratio)
    ///
    /// Returns the contrast ratio of this color with [other], which ranges from 1 to 21 for in-gamut sRGB colors.
    func wcagContrastRatio<T: Color>(against other: T) -> Float {
        let l = self.wcagLuminance
        let r = other.wcagLuminance
        return ((max(l, r) + 0.05) / (min(l, r) + 0.05))
    }
}
