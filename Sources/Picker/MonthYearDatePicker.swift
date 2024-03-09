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

public struct MonthYearDatePicker: View {
    private let title: LocalizedStringKey
    private let titleColor: Color

    @Binding private var selection: Date?
    @Binding private var error: String?

    private var debounce: Debounce<Date>?

    @State private var month: Int?
    @State private var year: Int?

    public init(_ title: LocalizedStringKey = "", selection: Binding<Date?>, error: Binding<String?>? = nil, titleColor: Color = .secondary) {
        self.title = title
        _selection = selection
        _error = error ?? Binding.constant(nil)
        self.titleColor = titleColor

        if let selectedDate = selection.wrappedValue {
            _month = State(initialValue: selectedDate.month)
            _year = State(initialValue: selectedDate.year)
        } else {
            _month = State(initialValue: -1)
            _year = State(initialValue: -1)
        }

        debounce = Debounce<Date>(0.3) { [self] date in
            if date != _selection.wrappedValue {
                self.selection = date
            }
        }
    }

    public var body: some View {
        VStack(alignment: .leading) {
            if title != "" {
                Text(title)
                    .font(.caption)
                    .padding(.bottom, 5)
                    .foregroundColor(error != nil ? .red : titleColor)
            }

            HStack(alignment: .center, spacing: 20) {
                YearPicker("Year", selection: $year, error: error != nil ? Binding.constant("") : Binding.constant(nil), titleColor: titleColor)
                MonthPicker("Month", selection: $month, error: error != nil ? Binding.constant("") : Binding.constant(nil), titleColor: titleColor)
                Spacer()
            }

            if let error, !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .onChange(of: month) { newValue in
            guard newValue != -1, year != -1 else { return }
            let date = (_selection.wrappedValue ?? Date()).setting(month: newValue, day: 1, year: year)
            debounce?.call(date)
        }
        .onChange(of: year) { newValue in
            guard month != -1, newValue != -1 else { return }
            let date = (_selection.wrappedValue ?? Date()).setting(month: month, day: 1, year: newValue)
            debounce?.call(date)
        }
    }
}
