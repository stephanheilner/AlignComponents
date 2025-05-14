//
//  The MIT License (MIT)
//
//  Copyright © 2025 Stephan Heilner
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

import SwiftUI

public struct PickerButtonStyle: ButtonStyle {
    let tintColor: Color
    let foregroundColor: Color
    let selected: Bool

    public init(tintColor: Color = Color(UIColor.tertiarySystemGroupedBackground), foregroundColor: Color = .primary, selected: Bool = false) {
        self.tintColor = tintColor
        self.foregroundColor = foregroundColor
        self.selected = selected
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 44, maxHeight: .infinity)
            .padding(3)
            .background(configuration.isPressed ? (selected ? Color.accentColor : tintColor).opacity(0.6) : (selected ? Color.accentColor : tintColor))
            .foregroundColor(selected ? Color.white : foregroundColor)
            .cornerRadius(6)
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(foregroundColor.opacity(0.5), lineWidth: 0.5))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == PickerButtonStyle {
    static var picker: PickerButtonStyle { picker() }
    static func picker(tintColor: Color = Color(UIColor.tertiarySystemGroupedBackground), foregroundColor: Color = .primary, selected: Bool = false) -> PickerButtonStyle {
        PickerButtonStyle(tintColor: tintColor, foregroundColor: foregroundColor, selected: selected)
    }
}

#Preview {
    VStack {
        Button("Button 1") {}
            .buttonStyle(.picker())

        Button("Button 2") {}
            .buttonStyle(.picker)

        Button("Button 2") {}
            .buttonStyle(PickerButtonStyle())
    }
}
