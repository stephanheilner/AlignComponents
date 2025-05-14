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

public struct CompactDatePicker: View {
    private let title: LocalizedStringKey?
    private let titleColor: Color

    private var debounce: Debounce<Date>?
    private let yearRange: ClosedRange<Int>

    @State private var month: Int
    @State private var day: Int
    @State private var year: Int

    @State private var isShowingMonthPicker: Bool = false
    @State private var isShowingDayPicker: Bool = false
    @State private var isShowingYearPicker: Bool = false

    @Binding private var selection: Date?
    @Binding private var error: String?

    public init(_ title: LocalizedStringKey? = nil, selection: Binding<Date?>, isFuture: Bool = false, upToYear: Int = Date().year + 10, error: Binding<String?>? = nil, titleColor: Color = .secondary) {
        self.title = title
        _error = error ?? Binding.constant(nil)
        self.titleColor = titleColor

        _selection = selection
        if isFuture {
            yearRange = Date().year ... upToYear
        } else {
            yearRange = 1900 ... Date().year
        }

        if let selectedDate = selection.wrappedValue {
            _month = State(initialValue: selectedDate.month)
            _day = State(initialValue: selectedDate.day)
            _year = State(initialValue: selectedDate.year)
        } else {
            _month = State(initialValue: -1)
            _day = State(initialValue: -1)
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
            if let title {
                Text(title)
                    .font(.caption)
                    .padding(.bottom, 5)
                    .foregroundColor(error != nil ? .red : titleColor)
            }

            HStack(alignment: .center, spacing: 0) {
                Button {
                    isShowingMonthPicker = true
                } label: {
                    if month != -1 {
                        Text(String(month))
                            .foregroundColor(.primary)
                    } else {
                        Text("Month")
                            .foregroundColor(.accentColor)
                    }
                }
                Text("/").foregroundColor(.secondary)
                Button {
                    isShowingDayPicker = true
                } label: {
                    if day != -1 {
                        Text(String(day))
                            .foregroundColor(.primary)
                    } else {
                        Text("Day")
                            .foregroundColor(.accentColor)
                    }
                }
                Text("/").foregroundColor(.secondary)
                Button {
                    isShowingYearPicker = true
                } label: {
                    if year != -1 {
                        Text(String(year))
                            .foregroundColor(.primary)
                    } else {
                        Text("Year")
                            .foregroundColor(.accentColor)
                    }
                }
            }

            if let error, !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .onChange(of: month) { _, newValue in
            guard day != -1, newValue != -1, year != -1 else { return }
            let date = (_selection.wrappedValue ?? Date()).setting(month: newValue, day: day, year: year)
            debounce?.call(date)
        }
        .onChange(of: day) { _, newValue in
            guard newValue != -1, month != -1, year != -1 else { return }
            let date = (_selection.wrappedValue ?? Date()).setting(month: month, day: newValue, year: year)
            debounce?.call(date)
        }
        .onChange(of: year) { _, newValue in
            guard day != -1, month != -1, newValue != -1 else { return }
            let date = (_selection.wrappedValue ?? Date()).setting(month: month, day: day, year: newValue)
            debounce?.call(date)
        }
        .sheet(isPresented: $isShowingMonthPicker) {
            MonthPickerView(title: "Month", month: $month, showMonthNumber: true)
        }
        .sheet(isPresented: $isShowingDayPicker) {
            DayPickerView(title: "Day", month: month, day: $day)
        }
        .sheet(isPresented: $isShowingYearPicker) {
            YearPickerView(title: "Year", year: $year)
        }
    }

    @ViewBuilder
    func cancelButton() -> some View {
        Button("Cancel") {
            isShowingMonthPicker = false
            isShowingDayPicker = false
            isShowingYearPicker = false
        }
        .buttonStyle(.plain)
    }
}
