//
//  RGBInt.swift
//  CoreColor
//
//  Created by yukonblue on 10/14/2022.
//

struct RGBInt {

    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8

    ///
    /// The packed rgba 32-bit unsigned integer.
    ///
    var rgba: UInt32 {
        (UInt32(r) << 24) | (UInt32(g) << 16) | (UInt32(b) << 8) | UInt32(a)
    }

    var redFloat: Float {
        Float(r) / 255.0
    }

    var greenFloat: Float {
        Float(g) / 255.0
    }

    var blueFloat: Float {
        Float(b) / 255.0
    }

    var hex: String {
        fatalError("")
    }
}
