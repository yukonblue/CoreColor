//
//  RGBColorSpaces.swift
//  CoreColor
//
//  Created by yukonblue on 10/14/2022.
//

import simd

fileprivate let SRGB_R = xyY(x: 0.6400, y: 0.3300)

fileprivate let SRGB_G = xyY(x: 0.3000, y: 0.6000)

fileprivate let SRGB_B = xyY(x: 0.1500, y: 0.0600)

/// Set of pre-defined RGB color spaces.
public enum RGBColorSpaces {

    ///
    /// sRGB color space
    ///
    /// ### References
    /// - [IEC 61966-2-1](https://webstore.iec.ch/publication/6169)
    ///
    static public let sRGB: RGBColorSpace = RGBColorSpace(
        name: "sRGB",
        whitePoint: Illuminant.D65,
        transferFunctions: SRGBTransferFunctions(),
        r: SRGB_R,
        g: SRGB_G,
        b: SRGB_B
    )

    ///
    /// Linear sRGB color space
    ///
    /// ### References
    /// - [IEC 61966-2-1](https://webstore.iec.ch/publication/6169)
    ///
    static public let LinearSRGB: RGBColorSpace = RGBColorSpace(
        name: "Linear sRGB",
        whitePoint: Illuminant.D65,
        transferFunctions: LinearTransferFunctions(),
        r: SRGB_R,
        g: SRGB_G,
        b: SRGB_B
    )

    ///
    /// Adobe RGB 1998 color space
    ///
    /// The CSS Color Module 4 calls this space `a98-rgb`.
    ///
    /// ### References
    /// - [Adobe RGB (1998) Color Image Encoding](https://www.adobe.com/digitalimag/pdfs/AdobeRGB1998.pdf)
    ///
    static public let AdobeRGB: RGBColorSpace = RGBColorSpace(
        name: "Adobe RGB",
        whitePoint: Illuminant.D65,
        transferFunctions: GammaTransferFunctions(gamma: 2.19921875),
        r: xyY(x: 0.64, y: 0.33),
        g: xyY(x: 0.21, y: 0.71),
        b: xyY(x: 0.15, y: 0.06)
    )

    /**
     * Display P3 color space
     *
     * The CSS Color Module 4 calls this space `display-p3`.
     *
     * ### References
     * - [Apple](https://developer.apple.com/documentation/coregraphics/cgcolorspace/1408916-displayp3)
     * - [RP 431-2:2011](https://ieeexplore.ieee.org/document/7290729)
     * - [Digital Cinema System Specification - Version 1.1](https://www.dcimovies.com/archives/spec_v1_1/DCI_DCinema_System_Spec_v1_1.pdf)
     */
    static public let DisplayP3: RGBColorSpace = RGBColorSpace(
        name: "Display P3",
        whitePoint: Illuminant.D65,
        transferFunctions: SRGBTransferFunctions(),
        r: xyY(x: 0.680, y: 0.320),
        g: xyY(x: 0.265, y: 0.690),
        b: xyY(x: 0.150, y: 0.060)
    )
}

/// RGB color space.
public struct RGBColorSpace: RGBColorSpaceRepresentable {

    public func convert<T>(from srcColor: T) -> RGB where T : Color {
        if let srcRGBColor = srcColor as? RGB {
            return srcRGBColor.convert(toRGBColorSpace: self)
        }
        return srcColor.toXYZ().to(rgbSpace: self)
    }

    public typealias ColorModel = RGB

    init(name: String, whitePoint: WhitePoint, transferFunctions: RGBTransferFunctions, r: xyY, g: xyY, b: xyY) {
        self.name = name
        self.whitePoint = whitePoint
        self.transferFunctions = transferFunctions
        self.r = r
        self.g = g
        self.b = b
    }

    var matrixToXyz: matrix_float3x3 {
        rgbToXyzMatrix(whitePoint: whitePoint, r: r, g: g, b: b)
    }

    var matrixFromXyz: matrix_float3x3 {
        matrixToXyz.inverse
    }

    public let components: [ColorComponentInfo] = rectangularComponentInfo(name: "RGB")

    public let name: String
    public let whitePoint: WhitePoint
    let transferFunctions: RGBTransferFunctions

    let r: xyY
    let g: xyY
    let b: xyY

    public static func == (lhs: RGBColorSpace, rhs: RGBColorSpace) -> Bool {
        lhs.name == rhs.name && lhs.components == rhs.components && lhs.whitePoint == rhs.whitePoint &&
        lhs.matrixFromXyz == rhs.matrixFromXyz && lhs.matrixToXyz == rhs.matrixToXyz &&
        lhs.transferFunctions.signature == rhs.transferFunctions.signature &&
        lhs.r == rhs.r &&
        lhs.g == rhs.g &&
        lhs.b == rhs.b
    }
}

// [SMPTE RP 177-1993](http://car.france3.mars.free.fr/Formation%20INA%20HD/HDTV/HDTV%20%202007%20v35/SMPTE%20normes%20et%20confs/rp177.pdf)
private func rgbToXyzMatrix(whitePoint: WhitePoint, r: xyY, g: xyY, b: xyY) -> matrix_float3x3 {
    /**
     primaries = Matrix(
             r.x, g.x, b.x,
             r.y, g.y, b.y,
             r.z, g.z, b.z,
         )
     */

    let primaries = matrix_float3x3(columns: (simd_float3(x: r.x, y: r.y, z: r.z),
                                              simd_float3(x: g.x, y: g.y, z: g.z),
                                              simd_float3(x: b.x, y: b.y, z: b.z)))

    let wp = whitePoint.chromaticity

    let CP = primaries.inverse * simd_float3(x: wp.X, y: wp.Y, z: wp.Z)

    return primaries * matrix_float3x3(diagonal: SIMD3<Float>(CP.x, CP.y, CP.z))
}
