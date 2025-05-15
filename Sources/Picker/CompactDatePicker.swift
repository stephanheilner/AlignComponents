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

    @State private var selectedMonth: Int
    @State private var selectedDay: Int
    @State private var selectedYear: Int

    @State private var pickerType: PickerType?

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
            _selectedMonth = State(initialValue: selectedDate.month)
            _selectedDay = State(initialValue: selectedDate.day)
            _selectedYear = State(initialValue: selectedDate.year)
        } else {
            _selectedMonth = State(initialValue: -1)
            _selectedDay = State(initialValue: -1)
            _selectedYear = State(initialValue: -1)
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
                    pickerType = .month
                } label: {
                    if selectedMonth != -1 {
                        Text(String(selectedMonth))
                    } else {
                        Text("Month")
                    }
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)

                Text("/").foregroundColor(.secondary)

                Button {
                    pickerType = .day
                } label: {
                    if selectedDay != -1 {
                        Text(String(selectedDay))
                    } else {
                        Text("Day")
                    }
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)

                Text("/").foregroundColor(.secondary)

                Button {
                    pickerType = .year
                } label: {
                    if selectedYear != -1 {
                        Text(String(selectedYear))
                    } else {
                        Text("Year")
                    }
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
            }

            if let error, !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .onChange(of: selectedMonth) { _, newValue in
            guard selectedDay != -1, newValue != -1, selectedYear != -1 else { return }
            let date = (_selection.wrappedValue ?? Date()).setting(month: newValue, day: selectedDay, year: selectedYear)
            debounce?.call(date)
        }
        .onChange(of: selectedDay) { _, newValue in
            guard newValue != -1, selectedMonth != -1, selectedYear != -1 else { return }
            let date = (_selection.wrappedValue ?? Date()).setting(month: selectedMonth, day: newValue, year: selectedYear)
            debounce?.call(date)
        }
        .onChange(of: selectedYear) { _, newValue in
            guard selectedDay != -1, selectedMonth != -1, newValue != -1 else { return }
            let date = (_selection.wrappedValue ?? Date()).setting(month: selectedMonth, day: selectedDay, year: newValue)
            debounce?.call(date)
        }
        .sheet(item: $pickerType) { pickerType in
            switch pickerType {
            case .month:
                MonthPickerView(title: "Month", month: $selectedMonth)
            case .day:
                DayPickerView(month: selectedMonth, year: selectedYear, selection: $selectedDay)
            case .year:
                YearPickerView(title: "Year", year: $selectedYear, range: yearRange)
            }
        }
    }
}

private enum PickerType: String, Identifiable {
    case month
    case day
    case year

    var id: String { rawValue }
}
