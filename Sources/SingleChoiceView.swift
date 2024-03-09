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

public struct SingleChoiceView<Selectable: Identifiable & Hashable>: View {
    let title: LocalizedStringKey
    let options: [Selectable]
    let optionToString: (Selectable) -> String
    var selected: Binding<Selectable?>
    var showValueAsTitle: Bool = false

    public init(title: LocalizedStringKey, options: [Selectable], optionToString: @escaping (Selectable) -> String, selected: Binding<Selectable?>, showValueAsTitle: Bool = false) {
        self.title = title
        self.options = options
        self.optionToString = optionToString
        self.selected = selected
        self.showValueAsTitle = showValueAsTitle
    }

    public init(title: String, options: [Selectable], optionToString: @escaping (Selectable) -> String, selected: Binding<Selectable?>, showValueAsTitle: Bool = false) {
        self.init(
            title: LocalizedStringKey(title),
            options: options,
            optionToString: optionToString,
            selected: selected,
            showValueAsTitle: showValueAsTitle
        )
    }

    private func text() -> Text {
        if let selected = selected.wrappedValue {
            Text(optionToString(selected))
                .foregroundColor(.primary)
        } else {
            Text(Image(systemName: "chevron.right"))
                .foregroundColor(.secondary)
        }
    }

    public var body: some View {
        NavigationLink(destination: LazyView { selectionView() }) {
            if showValueAsTitle {
                text().multilineTextAlignment(.leading)
            } else {
                HStack {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)

                    Spacer()

                    text().multilineTextAlignment(.trailing)
                }
            }
        }
    }

    @ViewBuilder
    private func selectionView() -> some View {
        SingleChoiceSelectionView(title: title, options: options, optionToString: optionToString, selected: selected)
    }
}

public struct SingleChoiceSelectionView<Selectable: Identifiable & Hashable>: View {
    @Environment(\.presentationMode) private var presentationMode

    let title: LocalizedStringKey
    let options: [Selectable]
    let optionToString: (Selectable) -> String
    @Binding var selected: Selectable?

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

                        if selected?.id == selectable.id {
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

    private func toggleSelection(selectable: Selectable?) {
        guard let selectable else { return }
        selected = selectable
        presentationMode.wrappedValue.dismiss()
    }
}
