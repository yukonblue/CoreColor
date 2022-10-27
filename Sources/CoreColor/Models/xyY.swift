//
//  xyY.swift
//  CoreColor
//
//  Created by yukonblue on 10/14/2022.
//

/// Representation of CIE chromaticity.
public struct xyY: Equatable {

    public let x: Float
    public let y: Float
    public let Y: Float = 1.0

    public var z: Float {
        1 - x - y
    }

    public var X: Float {
        x * Y / y
    }

    public var Z: Float {
        (1 - x - y) * Y / y
    }
}
