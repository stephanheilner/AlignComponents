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

public struct FloatingLabelTextField: View {
    @Binding private var text: String
    @Binding private var error: String?

    @State private var isSelected: Bool = false
    @State private var isPasswordHidden: Bool = false
    @State private var isSecureTextEntry: Bool = false
    @FocusState private var isFocused: Bool

    private var placeholder: LocalizedStringKey = ""
    private var isFloating: Bool { !text.isEmpty }

    public init(_ placeholder: String = "", text: Binding<String>, error: Binding<String?>? = nil) {
        self.init(LocalizedStringKey(placeholder), text: text, error: error)
    }

    public init(_ placeholder: LocalizedStringKey = "", text: Binding<String>, isSecure: Bool = false, error: Binding<String?>? = nil) {
        _text = text
        _error = error ?? Binding.constant(nil)

        self.placeholder = placeholder
        isSecureTextEntry = isSecure
        isPasswordHidden = isSecure
    }

    public var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                titleView()

                HStack {
                    if isPasswordHidden {
                        SecureField("", text: $text)
                            .focused($isFocused)
                            .modifier(ModifierButton(text: $text, isPasswordHidden: $isPasswordHidden, isSecureTextEntry: isSecureTextEntry, isFocused: isFocused))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(.top, 16)
                            .offset(y: 4)
                            .multilineTextAlignment(.leading)
                            .allowsHitTesting(true)
                    } else {
                        TextField("", text: $text)
                            .focused($isFocused)
                            .modifier(ModifierButton(text: $text, isPasswordHidden: $isPasswordHidden, isSecureTextEntry: isSecureTextEntry, isFocused: isFocused))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(.top, 16)
                            .multilineTextAlignment(.leading)
                            .offset(y: 4)
                            .allowsHitTesting(true)
                    }
                }
            }

            if let error, !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    @ViewBuilder
    private func titleView() -> some View {
        Text(placeholder)
            .foregroundColor(error != nil ? .red : isFocused && isFloating ? .accentColor : .secondary)
            .font(isFloating ? .caption : .body)
            .animation(.easeIn(duration: 0.1), value: isFloating)
            .padding(.top, isFloating ? 0 : 16)
            .offset(y: isFloating ? 0 : 4)
            .allowsHitTesting(false)
    }
}

private struct ModifierButton: ViewModifier {
    @Binding var text: String
    @Binding var isPasswordHidden: Bool
    var isSecureTextEntry: Bool
    var isFocused: Bool

    func body(content: Content) -> some View {
        HStack {
            content

            if isSecureTextEntry {
                Button(action: { isPasswordHidden.toggle() }) {
                    Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                        .accentColor(Color(UIColor.opaqueSeparator))
                }
            } else if !text.isEmpty, isFocused {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
            }
        }
    }
}
