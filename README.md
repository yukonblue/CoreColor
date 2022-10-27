## Color modelling and conversion framework in Swift
<img src="Assets/CoreColor_Banner.png" alt="CoreColor">

[![Build and Test](https://github.com/yukonblue/CoreColor/actions/workflows/swift.yml/badge.svg)](https://github.com/yukonblue/CoreColor/actions/workflows/swift.yml)

## Overview

*CoreColor* is a color modelling and conversion framework written in pure Swift.
It is designed for a for a wide range of audiences, including visual designers and artists,
color enthusiasts, as well as those that work in the scentific industry.

*CoreColor* provides the modelling for a set of common color models and associated colorspaces,
including those that many are familiar with, including RGB, CMYK, HSL, HSV, LAB, and XYZ,
as well as facilities for converting between any one of the color models to the other.

## Example

The interfaces of *CoreColor* are simple and intuitive to use. Here's an example
to convert an instance of RGB color model in sRGB colorspace to the equivalent in
CMYK model.

```swift
import CoreColor

let rgb = RGB(r: 0.40, g: 0.50, b: 0.60, alpha: 1.0, space: RGBColorSpaces.sRGB)
print(rgb) // RGB(r: 0.4, g: 0.5, b: 0.6, alpha: 1.0, space: CoreColor.RGBColorSpace(...))

let cmyk = rgb.toCMYK()
print(cmyk) // CMYK(c: 0.3333334, m: 0.1666667, y: 0.0, k: 0.39999998, alpha: 1.0)
```

## License

*CoreColor* is licensed under the [MIT License](https://choosealicense.com/licenses/mit/).

## Credits

*CoreColor* is a project of [@yukonblue](https://github.com/yukonblue).
