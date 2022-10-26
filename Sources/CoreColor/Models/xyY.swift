//
//  xyY.swift
//  CoreColor
//
//  Created by yukonblue on 10/14/2022.
//

public struct xyY: Equatable {

    let x: Float
    let y: Float
    let Y: Float = 1.0

    var z: Float {
        1 - x - y
    }

    var X: Float {
        x * Y / y
    }

    var Z: Float {
        (1 - x - y) * Y / y
    }
}
