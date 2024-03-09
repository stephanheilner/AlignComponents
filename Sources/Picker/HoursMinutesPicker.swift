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

public struct HoursMinutesPicker: View {
    private let title: LocalizedStringKey
    private let titleColor: Color
    private var debounce: Debounce<TimeInterval>?

    @Binding var selection: TimeInterval?
    @Binding private var error: String?

    @State private var hours: Int?
    @State private var minutes: Int?

    public init(_ title: LocalizedStringKey = "", selection: Binding<TimeInterval?>, error: Binding<String?>? = nil, titleColor: Color = .secondary) {
        self.title = title
        _selection = selection
        _error = error ?? Binding.constant(nil)
        self.titleColor = titleColor

        if let seconds = selection.wrappedValue {
            _hours = State(initialValue: Int(seconds / 3600))
            _minutes = State(initialValue: Int((seconds.truncatingRemainder(dividingBy: 3600) / 60).rounded()))
        } else {
            _hours = State(initialValue: -1)
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
                           selection: $hours,
                           error: error != nil ? Binding.constant("") : Binding.constant(nil),
                           titleColor: titleColor)
                Text(":").padding(.top, 10)
                MinutesPicker("Minutes",
                              selection: $minutes,
                              error: error != nil ? Binding.constant("") : Binding.constant(nil),
                              titleColor: titleColor)
                Spacer()
            }

            if let error, !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .onChange(of: hours) { newValue in
            guard let newValue, newValue != -1, let minutes, minutes != -1 else { return }
            let seconds = TimeInterval((newValue * 3600) + (minutes * 60))
            debounce?.call(seconds)
        }
        .onChange(of: minutes) { newValue in
            guard let hours, hours != -1, let newValue, newValue != -1 else { return }
            let seconds = TimeInterval((hours * 3600) + (newValue * 60))
            debounce?.call(seconds)
        }
    }
}
