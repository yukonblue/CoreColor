//
//  WhitePoint.swift
//  CoreColor
//
//  Created by yukonblue on 10/14/2022.
//

/// Abstraction of CIE white point.
public struct WhitePoint: Equatable {

    /// The canonical name of the white point.
    let name: String

    /// The CIE chromaticity of the white point.
    let chromaticity: xyY
}

/// Pre-defined set of white points.
public struct Illuminant {

    ///
    /// CIE 1931 2° Standard Illuminant A.
    ///
    /// This illuminant has a CCT of 2856K.
    ///
    static public let A: WhitePoint = .init(name: "A", chromaticity: xyY(x: 0.44758, y: 0.40745))

    ///
    /// CIE 1931 2° Standard Illuminant B.
    ///
    /// This illuminant has a CCT of 4874K.
    ///
    static public let B: WhitePoint = .init(name: "B", chromaticity: xyY(x: 0.34842, y: 0.35161))

    ///
    /// CIE 1931 2° Standard Illuminant C.
    ///
    /// This illuminant has a CCT of 6774K.
    ///
    static public let C: WhitePoint = .init(name: "C", chromaticity: xyY(x: 0.31006, y: 0.31616))

    ///
    /// CIE 1931 2° Standard Illuminant D50.
    ///
    /// This illuminant has a CCT of 5003K.
    ///
    static public let D50: WhitePoint = .init(name: "D50", chromaticity: xyY(x: 0.34570, y: 0.35850))

    ///
    /// CIE 1931 2° Standard Illuminant D55.
    ///
    /// This illuminant has a CCT of 5503K.
    ///
    static public let D55: WhitePoint = .init(name: "D55", chromaticity: xyY(x: 0.33243, y: 0.34744))

    ///
    /// CIE 1931 2° Standard Illuminant D65.
    ///
    /// This illuminant has a CCT of 6504K.
    ///
    static public let D65: WhitePoint = .init(name: "D65", chromaticity: xyY(x: 0.31270, y: 0.32900))

    ///
    /// CIE 1931 2° Standard Illuminant D75.
    ///
    /// This illuminant has a CCT of 7504K.
    ///
    static public let D75: WhitePoint = .init(name: "D75", chromaticity: xyY(x: 0.29903, y: 0.31488))

    ///
    /// CIE 1931 2° Standard Illuminant E.
    ///
    /// This illuminant has a CCT of 5454K.
    ///
    static public let E: WhitePoint = .init(name: "E", chromaticity: xyY(x: 1.0 / 3.0, y: 1.0 / 3.0))
}
