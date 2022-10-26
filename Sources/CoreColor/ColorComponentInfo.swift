//
//  ColorComponentInfo.swift
//  CoreColor
//
//  Created by yukonblue on 10/25/2022.
//

public struct ColorComponentInfo: Equatable {

    /// The name of this component.
    let name: String

    /// `true` if this component uses polar coordinates (e.g. a hue),
    /// and `false` if it's rectangular.
    let isPolar: Bool
}

internal func rectangularComponentInfo(name: String) -> [ColorComponentInfo] {
    Array(name).map { ColorComponentInfo(name: String($0), isPolar: false) } + [ColorComponentInfo(name: "alpha", isPolar: false)]
}

internal func polarComponentInfo(name: String) -> [ColorComponentInfo] {
    Array(name).map { ColorComponentInfo(name: String($0), isPolar: $0 == "H") } + [ColorComponentInfo(name: "alpha", isPolar: false)]
}
