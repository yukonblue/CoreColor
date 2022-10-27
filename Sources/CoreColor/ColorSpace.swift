//
//  ColorSpace.swift
//  CoreColor
//
//  Created by yukonblue on 10/14/2022.
//

/// Color space abstraction.
public protocol ColorSpace: Equatable {

    /// The associated color model of the color space.
    associatedtype ColorModel: Color

    /// Returns the canonical name of the color space.
    var name: String { get }

    /// Returns the set of components associated with this color space.
    var components: [ColorComponentInfo] { get }

    /// Converts a given color model instance to the equivalent in this color space.
    func convert<T: Color>(from: T) -> ColorModel
}

extension ColorSpace  {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name && lhs.components == rhs.components
    }
}
