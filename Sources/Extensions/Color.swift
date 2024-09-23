//
//  The MIT License (MIT)
//
//  Copyright © 2024 Stephan Heilner
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the  Software), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import SwiftUI
import UIKit

public extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }

//    func rgb() -> Int? {
//        var fRed: CGFloat = 0
//        var fGreen: CGFloat = 0
//        var fBlue: CGFloat = 0
//        var fAlpha: CGFloat = 0
//
//
//
//        if self.re(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
//            let iRed = Int(fRed * 255.0)
//            let iGreen = Int(fGreen * 255.0)
//            let iBlue = Int(fBlue * 255.0)
//            let iAlpha = Int(fAlpha * 255.0)
//
//            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
//            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
//            return rgb
//        } else {
//            // Could not extract RGBA components:
//            return nil
//        }
//    }

    // UIKit Colors
    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)

    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)

    func inverted() -> Color {
        let uiColor = UIColor(self)
        return Color(uiColor.inverted())
    }
}

struct RGBA {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
}

public extension UIColor {
    static let accentColor = UIColor(named: "AccentColor") ?? UIColor(Color.accentColor)

    internal func rgba() -> RGBA {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }

    func hexString(_: UIColor) -> String {
        let multiplier = CGFloat(255.999999)
        let rgba = rgba()

        if rgba.alpha == 1.0 {
            return String(
                format: "%02lX%02lX%02lX",
                Int(rgba.red * multiplier),
                Int(rgba.green * multiplier),
                Int(rgba.blue * multiplier)
            )
        }

        return String(
            format: "%02lX%02lX%02lX%02lX",
            Int(rgba.red * multiplier),
            Int(rgba.green * multiplier),
            Int(rgba.blue * multiplier),
            Int(rgba.alpha * multiplier)
        )
    }

    func inverted() -> UIColor {
        let rgba = rgba()
        return UIColor(red: 255 - rgba.red, green: 255 - rgba.green, blue: 255 - rgba.blue, alpha: rgba.alpha)
    }

    static func dynamicColor(_ defaultColor: UIColor, darkColor: UIColor? = nil) -> UIColor {
        guard let darkColor
        else { return defaultColor }

        return UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return darkColor
            case .light, .unspecified:
                return defaultColor
            @unknown default:
                return defaultColor
            }
        }
    }

    var lightModeColor: UIColor {
        resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
    }

    var darkModeColor: UIColor {
        resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
    }
}

public extension Color {
    static func dynamicColor(_ defaultColor: Color, darkColor: Color? = nil) -> Color {
        Color(UIColor.dynamicColor(UIColor(defaultColor), darkColor: darkColor.flatMap { UIColor($0) }))
    }
}
