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

public struct TimePicker: View {
    private let title: LocalizedStringKey
    private let titleColor: Color
    private var debounce: Debounce<TimeInterval>?

    @Binding var selection: TimeInterval?
    @Binding private var error: String?

    @State private var hour: Int?
    @State private var minutes: Int?
    @State private var dayPeriod: DayPeriod = .am

    public init(_ title: LocalizedStringKey = "", selection: Binding<TimeInterval?>, error: Binding<String?>? = nil, titleColor: Color = .secondary) {
        self.title = title
        _selection = selection
        _error = error ?? Binding.constant(nil)
        self.titleColor = titleColor

        if let seconds = selection.wrappedValue {
            let hour = Int(seconds / 3600)
            let adjustedHour: Int
            if hour > 12 {
                adjustedHour = hour - 12
                _dayPeriod = State(initialValue: .pm)
            } else {
                adjustedHour = hour
                _dayPeriod = State(initialValue: .am)
            }
            _hour = State(initialValue: adjustedHour)
            _minutes = State(initialValue: Int((seconds.truncatingRemainder(dividingBy: 3600) / 60).rounded()))
        } else {
            _hour = State(initialValue: -1)
            _minutes = State(initialValue: -1)
        }

        debounce = Debounce<TimeInterval>(0.3) { [self] seconds in
            if seconds != _selection.wrappedValue {
                self.selection = seconds
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
            HStack(alignment: .center, spacing: 2) {
                HourPicker("Hour",
                           selection: $hour,
                           error: error != nil ? Binding.constant("") : Binding.constant(nil),
                           titleColor: titleColor,
                           hoursRange: 1 ... 12)
                Text(":").padding(.top, 10)
                MinutesPicker("Minutes",
                              selection: $minutes,
                              error: error != nil ? Binding.constant("") : Binding.constant(nil),
                              titleColor: titleColor)

                CapsuleSegmentedControl(
                    items: DayPeriod.allCases,
                    selection: $dayPeriod,
                    accentColor: Color.accentColor,
                    title: { $0.title }
                )
                .frame(width: 80)
                .padding(.top, 10)
                .padding(.leading, 20)

                Spacer()
            }

            if let error, !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .onChange(of: hour) { _, newValue in
            guard let newValue, newValue != -1, let minutes, minutes != -1 else { return }
            let seconds = convertToSeconds(hour: newValue, minutes: minutes, dayPeriod: dayPeriod)
            debounce?.call(seconds)
        }
        .onChange(of: minutes) { _, newValue in
            guard let hour, hour != -1, let newValue, newValue != -1 else { return }
            let seconds = convertToSeconds(hour: hour, minutes: newValue, dayPeriod: dayPeriod)
            debounce?.call(seconds)
        }
        .onChange(of: dayPeriod) { _, newValue in
            guard let hour, hour != -1, let minutes, minutes != -1 else { return }
            let seconds = convertToSeconds(hour: hour, minutes: minutes, dayPeriod: newValue)
            debounce?.call(seconds)
        }
    }

    private func convertToSeconds(hour: Int, minutes: Int, dayPeriod: DayPeriod) -> TimeInterval {
        let hoursAdjusted = switch dayPeriod {
        case .am: hour
        case .pm: hour + 12
        }
        return TimeInterval((hoursAdjusted * 3600) + (minutes * 60))
    }
}
