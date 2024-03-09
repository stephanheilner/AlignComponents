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

import Foundation
import SwiftUI

public struct MultipleChoiceView<Selectable: Identifiable & Hashable>: View {
    let title: String
    let options: [Selectable]
    let optionToString: (Selectable) -> String
    var selected: Binding<Set<Selectable>>

    public var body: some View {
        NavigationLink(destination: LazyView { multiSelectionView() }) {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(title)
                        .lineLimit(nil)
                        .foregroundColor(.secondary)
                        .font(!selected.wrappedValue.isEmpty ? .caption : .body)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(selected.wrappedValue)) { option in
                        Text("\u{2022} \(optionToString(option))")
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .font(.subheadline)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func multiSelectionView() -> some View {
        MultipleChoiceSelectionView(title: title, options: options, optionToString: optionToString, selected: selected)
    }
}

public struct MultipleChoiceSelectionView<Selectable: Identifiable & Hashable>: View {
    let title: String
    let options: [Selectable]
    let optionToString: (Selectable) -> String
    @Binding var selected: Set<Selectable>

    public var body: some View {
        List {
            ForEach(options) { selectable in
                Button(action: {
                    toggleSelection(selectable: selectable)
                }) {
                    HStack {
                        Text(optionToString(selectable))
                            .foregroundColor(.primary)
                        Spacer()

                        if selected.contains(where: { $0.id == selectable.id }) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .tag(selectable.id)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(title)
    }

    private func toggleSelection(selectable: Selectable) {
        if let existingIndex = selected.firstIndex(where: { $0.id == selectable.id }) {
            selected.remove(at: existingIndex)
        } else {
            selected.insert(selectable)
        }
    }
}
