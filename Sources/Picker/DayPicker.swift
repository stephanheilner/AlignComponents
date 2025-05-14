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

import Foundation
import SwiftUI

public struct DayPicker: View {
    private let titleKey: LocalizedStringKey
    private let titleColor: Color

    @Binding private var selection: Int?
    @Binding private var error: String?

    @State private var isShowingPicker: Bool = false
    @State private var selectedDay: Int
    private var month: Int
    private var year: Int

    public init(_ titleKey: LocalizedStringKey, selection: Binding<Int?>, month: Int? = nil, year: Int? = nil, error: Binding<String?>? = nil, titleColor: Color = .secondary, file _: String = #file, line _: Int = #line) {
        self.titleKey = titleKey
        _selection = selection
        self.month = month ?? Date().month
        self.year = year ?? Date().year
        _error = error ?? Binding.constant(nil)
        self.titleColor = titleColor

        if let day = selection.wrappedValue {
            _selectedDay = State(initialValue: day)
        } else {
            _selectedDay = State(initialValue: -1)
        }
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(titleKey)
                .font(.caption)
                .foregroundColor(error != nil ? .red : titleColor)

            Button(action: {
                isShowingPicker.toggle()
            }, label: {
                let title = (selectedDay == -1 ? "--" : String(selectedDay)) + " "
                Text(title) + Text(Image(systemName: "chevron.up.chevron.down"))
            })
            .buttonStyle(.plain)
            .foregroundColor(error != nil ? .red : .accentColor)

            if let error, !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .sheet(isPresented: $isShowingPicker) {
            DayPickerView(month: month, year: year, selection: $selectedDay)
        }
        .onChange(of: selectedDay) { _, newValue in
            if newValue != _selection.wrappedValue {
                selection = newValue
            }
        }
    }
}
