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

public struct YearPickerView: View {
    var title: LocalizedStringKey
    @Binding var year: Int
    var range: ClosedRange<Int> = 1900 ... Date().year
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .top) {
                    cancelButton()
                    Spacer()
                }
                HStack(alignment: .top) {
                    Spacer()
                    Text(title)
                        .font(.body)
                        .fontWeight(.bold)
                    Spacer()
                }
            }

            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 10) {
                    ForEach(range.reversed(), id: \.self) { year in
                        Button(String(year)) {
                            self.year = year
                            dismiss()
                        }
                        .buttonStyle(.picker(selected: self.year == year))
                    }
                }
            }
        }
        .padding(20)
        .background(Color(UIColor.systemBackground))
    }

    @ViewBuilder
    func cancelButton() -> some View {
        Button("Cancel") {
            dismiss()
        }
        .foregroundColor(.accentColor)
        .buttonStyle(.plain)
    }
}
