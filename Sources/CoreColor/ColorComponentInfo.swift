//
//  ColorComponentInfo.swift
//  CoreColor
//
//  Created by yukonblue on 10/25/2022.
//

/// An abstraction that encapsulates relevant information about
/// individual color components of a color space.
public struct ColorComponentInfo: Equatable {

    /// The name of this component.
    public let name: String

    /// Returns `true` if this component uses polar coordinates (e.g. a hue),
    /// and `false` if it's rectangular.
    public let isPolar: Bool
}

internal func rectangularComponentInfo(name: String) -> [ColorComponentInfo] {
    Array(name).map { ColorComponentInfo(name: String($0), isPolar: false) } + [ColorComponentInfo(name: "alpha", isPolar: false)]
}

internal func polarComponentInfo(name: String) -> [ColorComponentInfo] {
    Array(name).map { ColorComponentInfo(name: String($0), isPolar: $0 == "H") } + [ColorComponentInfo(name: "alpha", isPolar: false)]
}
