//
//  WhitePoint.swift
//  CoreColor
//
//  Created by yukonblue on 10/14/2022.
//

public struct WhitePoint: Equatable {

    let name: String
    let chromaticity: xyY
}

public struct Illuminant {

    ///
    /// CIE 1931 2° Standard Illuminant A
    ///
    /// This illuminant has a CCT of 2856K
    ///
    static let A: WhitePoint = .init(name: "A", chromaticity: xyY(x: 0.44758, y: 0.40745))

    ///
    /// CIE 1931 2° Standard Illuminant B
    ///
    /// This illuminant has a CCT of 4874K
    ///
    static let B: WhitePoint = .init(name: "B", chromaticity: xyY(x: 0.34842, y: 0.35161))

    ///
    /// CIE 1931 2° Standard Illuminant C
    ///
    /// This illuminant has a CCT of 6774K
    ///
    static let C: WhitePoint = .init(name: "C", chromaticity: xyY(x: 0.31006, y: 0.31616))

    ///
    /// CIE 1931 2° Standard Illuminant D50
    ///
    /// This illuminant has a CCT of 5003K
    ///
    static let D50: WhitePoint = .init(name: "D50", chromaticity: xyY(x: 0.34570, y: 0.35850))

    ///
    /// CIE 1931 2° Standard Illuminant D55
    ///
    /// This illuminant has a CCT of 5503K
    ///
    static let D55: WhitePoint = .init(name: "D55", chromaticity: xyY(x: 0.33243, y: 0.34744))

    ///
    /// CIE 1931 2° Standard Illuminant D65
    ///
    /// This illuminant has a CCT of 6504K
    ///
    static let D65: WhitePoint = .init(name: "D65", chromaticity: xyY(x: 0.31270, y: 0.32900))

    ///
    /// CIE 1931 2° Standard Illuminant D75
    ///
    /// This illuminant has a CCT of 7504K
    ///
    static let D75: WhitePoint = .init(name: "D75", chromaticity: xyY(x: 0.29903, y: 0.31488))

    ///
    /// CIE 1931 2° Standard Illuminant E
    ///
    /// This illuminant has a CCT of 5454K
    ///
    static let E: WhitePoint = .init(name: "E", chromaticity: xyY(x: 1.0 / 3.0, y: 1.0 / 3.0))
}
