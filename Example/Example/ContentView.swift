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

import AlignComponents
import SwiftUI

struct ContentView: View {
    @State var date: Date?
    @State var minutes: Int?
    @State var day: Int?
    @State var hours: Int?
    @State var month: Int?
    @State var monthYear: Date?
    @State var year: Int?
    @State var time: TimeInterval?
    @State var text: String = ""

    @State var dateError: String? = nil
    @State var minutesError: String? = nil
    @State var dayError: String? = "Day Error"
    @State var hoursError: String? = "Hours Error"
    @State var monthError: String? = "Month Error"
    @State var monthYearError: String? = "Month/Year Error"
    @State var yearError: String? = "Year Error"
    @State var timeError: String? = "Time Error"
    @State var textError: String? = "Text Error"

    var body: some View {
        List {
            Section("Normal") {
                MonthPicker("Month", selection: $month)
                DayPicker("Day", selection: $day, month: Date().month)
                YearPicker("Year", selection: $year)

                HourPicker("Hours", selection: $hours)
                MinutesPicker("Minutes", selection: $minutes)

                HoursMinutesPicker("", selection: $time)
                    .buttonStyle(.plain)
                MonthYearDatePicker("", selection: $monthYear)
                    .buttonStyle(.plain)
                MonthDayYearDatePicker("", selection: $date)
                    .buttonStyle(.plain)
                FloatingLabelTextField("Title", text: $text)
            }

            Section("Error") {
                MonthPicker("Month", selection: $month, error: $monthError)
                DayPicker("Day", selection: $day, month: Date().month, error: $dayError)
                YearPicker("Year", selection: $year, error: $yearError)

                HourPicker("Hours", selection: $hours, error: $hoursError)
                MinutesPicker("Minutes", selection: $minutes, error: $minutesError)

                HoursMinutesPicker("", selection: $time, error: $timeError)
                    .buttonStyle(.plain)
                MonthYearDatePicker("", selection: $monthYear, error: $monthError)
                    .buttonStyle(.plain)
                MonthDayYearDatePicker("", selection: $date, error: $dateError)
                    .buttonStyle(.plain)

                FloatingLabelTextField("Title", text: $text, error: $textError)
            }
        }
    }
}

#Preview {
    ContentView()
}
