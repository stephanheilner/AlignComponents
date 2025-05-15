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

public struct DayPickerView: View {
    private let calendar: Calendar
    private let title: LocalizedStringKey
    private var month: Int
    private var year: Int
    @Binding private var selectedDay: Int

    @Environment(\.dismiss) private var dismiss

    public init(_ titleKey: LocalizedStringKey? = nil, month: Int? = nil, year: Int? = nil, selection: Binding<Int>, file _: String = #file, line _: Int = #line) {
        let calendar = Calendar.autoupdatingCurrent

        self.calendar = calendar
        _selectedDay = selection
        self.month = month ?? Date().month

        let validMonth = (month ?? Date().month)
        let displayMonth = (1 ... 12).contains(validMonth) ? validMonth : 1
        let monthString = calendar.monthSymbols[displayMonth - 1]

        if let titleKey {
            title = titleKey
        } else {
            var titleText = monthString
            if let year {
                titleText += " \(String(year))"
            }
            title = LocalizedStringKey(titleText)
        }

        self.year = year ?? Date().year
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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

            let daysInMonth = Date().endOfMonth(month: month).day
            let firstOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
            let firstWeekday = calendar.component(.weekday, from: firstOfMonth) - 1

            // Previous month trailing days
            let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: firstOfMonth)!
            let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonthDate)!
            let daysInPreviousMonth = previousMonthRange.upperBound - previousMonthRange.lowerBound

            // Calculate remaining cells needed to complete the grid
            let totalCells = firstWeekday + daysInMonth
            let remainingCells = (7 - (totalCells % 7)) % 7

            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    // Days of week header
                    ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    if firstWeekday > 0 {
                        ForEach((daysInPreviousMonth - firstWeekday + 1) ... daysInPreviousMonth, id: \.self) { day in
                            Button(String(day)) {}
                                .disabled(true)
                        }
                    }

                    // Current month days

                    ForEach(1 ... daysInMonth, id: \.self) { day in
                        let pickerState: PickerState = selectedDay == day ? .selected : .active
                        Button(String(day)) {
                            selectedDay = day
                            dismiss()
                        }
                        .buttonStyle(PickerButtonStyle(pickerState: pickerState))
                    }

                    // Next month leading days
                    if remainingCells > 0 {
                        ForEach(1 ... remainingCells, id: \.self) { day in
                            Button(String(day)) {}
                                .disabled(true)
                        }
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
