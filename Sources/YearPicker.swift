//
//  The MIT License (MIT)
//
//  Copyright © 2023 Stephan Heilner
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

public struct YearPicker: View {
    private let titleKey: LocalizedStringKey
    private let range: ClosedRange<Int>

    @Binding private var selection: Int?
    @State private var isShowingPicker: Bool = false
    @State private var year: Int

    public init(_ titleKey: LocalizedStringKey, selection: Binding<Int?>, range: ClosedRange<Int> = 1900 ... Date().year) {
        self.titleKey = titleKey
        _selection = selection
        self.range = range

        if let year = selection.wrappedValue {
            _year = State(initialValue: year)
        } else {
            _year = State(initialValue: -1)
        }
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(titleKey)
                .font(.caption)
                .foregroundColor(.secondary)

            Button(action: {
                isShowingPicker.toggle()
            }, label: {
                let title = (year == -1 ? "--" : String(year)) + " "
                Text(title) + Text(Image(systemName: "chevron.up.chevron.down"))
            })
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
        }
        .sheet(isPresented: $isShowingPicker) {
            yearPickerView()
        }
        .onChange(of: year) { newValue in
            if newValue != _selection.wrappedValue {
                selection = newValue
            }
        }
    }

    @ViewBuilder
    func yearPickerView() -> some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .top) {
                    cancelButton()
                    Spacer()
                }
                HStack(alignment: .top) {
                    Spacer()
                    Text(titleKey)
                        .font(.title2)
                    Spacer()
                }
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 10) {
                ForEach(range.reversed(), id: \.self) { year in
                    Button(String(year)) {
                        self.year = year
                        isShowingPicker = false
                    }
                    .buttonStyle(.plain)
                    .frame(width: 50, height: 50, alignment: .center)
                    .background(Color.secondary)
                    .foregroundColor(Color(UIColor.systemBackground))
                    .cornerRadius(6)
                }
            }
        }
        .padding(20)
        .background(Color(UIColor.systemBackground))
    }

    @ViewBuilder
    func cancelButton() -> some View {
        Button("Cancel") {
            isShowingPicker = false
        }
        .buttonStyle(.plain)
    }
}
