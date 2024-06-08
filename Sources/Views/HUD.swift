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

    @Environment(\.dismissHUD) var dismissHUD
    @Environment(\.presentationMode) var presentationMode

    private let backgroundColor: Color
    private let cornerRadius: CGFloat

    public init(backgroundColor: Color = Color.darkGray, cornerRadius: CGFloat = 20, @ViewBuilder content: @escaping () -> Content) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.content = content
    }

    public var body: some View {
        content()
            .foregroundColor(Color.systemBackground)
            .padding(.horizontal, 12)
            .padding(16)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.primary, lineWidth: 1))
            .onReceive(dismissHUD) {
                presentationMode.wrappedValue.dismiss()
            }
    }
}

public struct HUDMessage {
    let title: LocalizedStringKey
    let text: LocalizedStringKey?
    let showSpinner: Bool
    var onDismiss: (() -> Void)?
    var onConfirm: (() -> Void)?

    public init(title: LocalizedStringKey, text: LocalizedStringKey? = nil, showSpinner: Bool = false, onDismiss: (() -> Void)? = nil, onConfirm: (() -> Void)? = nil) {
        self.title = title
        self.text = text
        self.showSpinner = showSpinner
        self.onDismiss = onDismiss
        self.onConfirm = onConfirm
    }

    public init(title: String, text: String? = nil, onDismiss: (() -> Void)? = nil, showSpinner: Bool = false, onConfirm: (() -> Void)? = nil) {
        self.title = LocalizedStringKey(title)
        self.text = text.flatMap { LocalizedStringKey($0) }
        self.showSpinner = showSpinner
        self.onDismiss = onDismiss
        self.onConfirm = onConfirm
    }
}

public struct HUDMessageView: View {
    let message: HUDMessage

    public init(message: HUDMessage) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: 10) {
            Text(message.title)
                .foregroundColor(.white)
                .fontWeight(.bold)

            if let text = message.text {
                Text(text)
                    .foregroundColor(.white)
            }

            if message.showSpinner {
                SpinnerView()
                    .frame(width: 60, height: 60)
            }

            if message.onConfirm != nil || message.onDismiss != nil {
                HStack {
                    Spacer()
                    if let onDismiss = message.onDismiss {
                        Button("Cancel", action: onDismiss)
                            .buttonStyle(CapsuleButtonStyle(tintColor: Color.white))
                        Spacer()
                    }
                    if let onConfirm = message.onConfirm {
                        Button("OK", action: onConfirm)
                            .buttonStyle(CapsuleFilledButtonStyle(tintColor: .white, textColor: .darkGray))
                        Spacer()
                    }
                }
                .padding(.top, 5)
            }
        }
    }
}

#Preview {
    HUD {
        HUDMessageView(message: HUDMessage(title: "Testing..."))
    }
}
