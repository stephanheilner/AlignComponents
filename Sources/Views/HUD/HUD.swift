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

public struct HUD<Content: View>: View {
    @ViewBuilder let content: () -> Content

    @Environment(\.dismissHUD) private var dismissHUD
    @Environment(\.presentationMode) private var presentationMode

    private let tintColor: Color
    private let textColor: Color
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let padding: CGFloat

    public init(tintColor: Color, textColor: Color, backgroundColor: Color, cornerRadius: CGFloat = 20, padding: CGFloat = 30, @ViewBuilder content: @escaping () -> Content) {
        self.tintColor = tintColor
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content
    }

    public var body: some View {
        content()
            .foregroundColor(Color.systemBackground)
            .padding(.horizontal, 12)
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(.primary.opacity(0.3), lineWidth: 1))
            .padding(.horizontal, padding)
            .onReceive(dismissHUD) {
                presentationMode.wrappedValue.dismiss()
            }
    }
}

#Preview {
    @State var hudMessage: HUDMessage? = HUDMessage(title: "Testing...")
    return Text("Hello World!")
        .hud(hudMessage: $hudMessage)
}
