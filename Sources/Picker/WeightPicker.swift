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

public struct WeightPicker: View {
    private let titleKey: LocalizedStringKey

    @Binding private var selection: String
    @State private var isShowingPicker: Bool = false
    @State private var weight: Int

    public init(_ titleKey: LocalizedStringKey = "", selection: Binding<String>) {
        self.titleKey = titleKey
        _selection = selection

        let weight = selection.wrappedValue.replacingOccurrences(of: "lbs", with: "").trimmed()
        if !weight.isEmpty, let lbs = Int(weight) {
            _weight = State(initialValue: lbs)
        } else {
            _weight = State(initialValue: -1)
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
                let title = (weight == -1 ? "--" : String(format: "%02d", weight)) + " "
                Text(title) + Text(Image(systemName: "chevron.up.chevron.down")) + Text(" lbs")
            })
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
        }
        .sheet(isPresented: $isShowingPicker) {
            weightPickerView()
        }
        .onChange(of: weight) { _, newValue in
            selection = String(format: "%d lbs", newValue)
        }
    }

    @ViewBuilder
    func weightPickerView() -> some View {
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
                ForEach(60 ... 700, id: \.self) { lbs in
                    Button(String(format: "%02d", lbs)) {
                        weight = lbs
                        isShowingPicker = false
                    }
                    .buttonStyle(.picker(selected: weight == lbs))
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
