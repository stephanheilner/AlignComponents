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

    // UIKit Colors
    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)

    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)

    static let lightGray = Color(0xF4F1EF)
    static let darkGray = Color(0x737270)

    static let hudBackground = Color.dynamicColor(lightGray, darkColor: darkGray)
    static let hudText = Color.dynamicColor(darkGray, darkColor: lightGray)
}

public extension UIColor {
    static let accentColor = UIColor(named: "AccentColor") ?? UIColor(Color.accentColor)

    func hexString(_ color: UIColor) -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        if alpha == 1.0 {
            return String(
                format: "%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }

        return String(
            format: "%02lX%02lX%02lX%02lX",
            Int(red * multiplier),
            Int(green * multiplier),
            Int(blue * multiplier),
            Int(alpha * multiplier)
        )
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
