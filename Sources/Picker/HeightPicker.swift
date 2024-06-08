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

public struct HeightPicker: View {
    private let title: LocalizedStringKey
    private var debounce: Debounce<(Int, Int)>?

    @Binding var selection: String
    @State private var feet: Int?
    @State private var inches: Int?

    public init(_ title: LocalizedStringKey = "", selection: Binding<String>) {
        self.title = title
        _selection = selection

        let height = selection.wrappedValue
        let parts = height.components(separatedBy: " ")
        if parts.count == 2,
           let feet = Int(parts[0].replacingOccurrences(of: "'", with: "")),
           let inches = Int(parts[1].replacingOccurrences(of: "\"", with: "")) {
            _feet = State(initialValue: feet)
            _inches = State(initialValue: inches)
        } else {
            _feet = State(initialValue: -1)
            _inches = State(initialValue: -1)
        }

        debounce = Debounce<(Int, Int)>(0.3) { [self] feet, inches in
            self.selection = String(format: "%d' %d\"", feet, inches)
        }
    }

    public var body: some View {
        VStack(alignment: .leading) {
            if title != "" {
                Text(title)
                    .font(.caption)
                    .padding(.bottom, 5)
            }
            HStack(alignment: .center, spacing: 2) {
                FeetPicker("Feet", selection: $feet)
                Text("' ").padding(.top, 10)
                InchesPicker("Inches", selection: $inches)
                Text("\" ").padding(.top, 10)
                Spacer()
            }
        }
        .onChange(of: feet) { newValue in
            guard let newValue, newValue != -1, let inches, inches != -1 else { return }
            debounce?.call((newValue, inches))
        }
        .onChange(of: inches) { newValue in
            guard let feet, feet != -1, let newValue, newValue != -1 else { return }
            debounce?.call((feet, newValue))
        }
    }
}
