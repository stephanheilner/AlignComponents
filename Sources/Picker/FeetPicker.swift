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

public struct FeetPicker: View {
    private let titleKey: LocalizedStringKey

    @Binding private var selection: Int?
    @State private var isShowingPicker: Bool = false
    @State private var feet: Int

    public init(_ titleKey: LocalizedStringKey, selection: Binding<Int?>) {
        self.titleKey = titleKey
        _selection = selection

        if let foot = selection.wrappedValue {
            _feet = State(initialValue: foot)
        } else {
            _feet = State(initialValue: -1)
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
                let title = (feet == -1 ? "--" : String(format: "%02d", feet)) + " "
                Text(title) + Text(Image(systemName: "chevron.up.chevron.down"))
            })
            .buttonStyle(.plain)
            .foregroundColor(.accentColor)
        }
        .sheet(isPresented: $isShowingPicker) {
            footPickerView()
        }
        .onChange(of: feet) { _, newValue in
            if newValue != _selection.wrappedValue {
                selection = newValue
            }
        }
    }

    @ViewBuilder
    func footPickerView() -> some View {
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
                ForEach(2 ... 9, id: \.self) { foot in
                    Button(String(format: "%02d", foot)) {
                        feet = foot
                        isShowingPicker = false
                    }
                    .buttonStyle(PickerButtonStyle())
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
