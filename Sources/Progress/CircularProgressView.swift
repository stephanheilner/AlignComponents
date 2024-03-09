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

import CoreGraphics
import Foundation
import SwiftUI

public struct CircularProgressView: View {
    let progress: Double
    var lineWidth: Float
    var showPercentText: Bool
    var footer: LocalizedStringKey?

    public init(progress: Double, lineWidth: Float = 10, showPercentText: Bool = false, footer: LocalizedStringKey?) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.showPercentText = showPercentText
        self.footer = footer
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.accentColor.opacity(0.3),
                    lineWidth: CGFloat(lineWidth)
                )
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(
                    Color.accentColor,
                    style: StrokeStyle(
                        lineWidth: CGFloat(lineWidth),
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)

            if showPercentText, let percent = NumberFormatter.percent.string(for: progress * 100) {
                VStack {
                    Text(percent)
                        .fontWeight(.bold)
                    if let footer {
                        Text(footer)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

extension NumberFormatter {
    static let percent: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.multiplier = 1
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter
    }()
}
