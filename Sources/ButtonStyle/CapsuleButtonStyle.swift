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

import SwiftUI

public struct CapsuleButtonStyle: ButtonStyle {
    private let tintColor: Color
    private var selected: Bool

    public init(tintColor: Color = .accentColor, selected: Bool = false) {
        self.tintColor = tintColor
        self.selected = selected
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.medium))
            .padding([.leading, .trailing], 22)
            .padding([.top, .bottom], 11)
            .foregroundColor(selected ? Color.white : (configuration.isPressed ? tintColor.opacity(0.6) : tintColor))
            .background(Capsule().fill(selected ? tintColor : Color.clear))
            .overlay(
                Capsule()
                    .stroke(selected ? tintColor : (configuration.isPressed ? tintColor.opacity(0.6) : tintColor), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == CapsuleButtonStyle {
    static var capsule: CapsuleButtonStyle { CapsuleButtonStyle() }
}

#Preview {
    VStack {
        Button("Button 1") {}
            .buttonStyle(CapsuleButtonStyle())

        Button("Button 2") {}
            .buttonStyle(.capsule)
    }
}