//
//  ColorSpace.swift
//  CoreColor
//
//  Created by yukonblue on 10/14/2022.
//

public protocol ColorSpace: Equatable {

    associatedtype ColorType: Color

    var name: String { get }

    var components: [ColorComponentInfo] { get }

    func convert<T: Color>(from: T) -> ColorType
}

extension ColorSpace  {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name && lhs.components == rhs.components
    }
}
