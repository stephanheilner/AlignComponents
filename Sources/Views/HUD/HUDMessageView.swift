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

public struct HUDMessageView: View {
    let message: HUDMessage
    let tintColor: Color
    let textColor: Color
    let backgroundColor: Color

    public init(message: HUDMessage, tintColor: Color, textColor: Color, backgroundColor: Color) {
        self.message = message
        self.tintColor = tintColor
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        VStack(spacing: 10) {
            Text(message.title)
                .foregroundColor(textColor)
                .multilineTextAlignment(.center)
                .fontWeight(.medium)

            if let text = message.text {
                Text(text)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
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
                            .buttonStyle(CapsuleButtonStyle(tintColor: tintColor))
                        Spacer()
                    }
                    if let onConfirm = message.onConfirm {
                        Button("OK", action: onConfirm)
                            .buttonStyle(CapsuleFilledButtonStyle(tintColor: tintColor, textColor: backgroundColor.inverted(), backgroundColor: backgroundColor))
                        Spacer()
                    }
                }
                .padding(.top, 5)
            }
        }
    }
}

extension Color {}
