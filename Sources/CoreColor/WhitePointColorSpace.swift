//
//  WhitePointColorSpace.swift
//  CoreColor
//
//  Created by yukonblue on 10/25/2022.
//

public protocol WhitePointColorSpace: ColorSpace {

    /// The white point that colors in this space are calculated relative to.
    var whitePoint: WhitePoint { get }
}

extension WhitePointColorSpace {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name && lhs.components == rhs.components && lhs.whitePoint == rhs.whitePoint
    }
}
