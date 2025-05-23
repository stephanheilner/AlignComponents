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

public struct MultipleChoiceView<Selectable: Identifiable & Hashable>: View {
    private let title: LocalizedStringKey
    private let options: [Selectable]
    private let optionToString: (Selectable) -> String
    private var selected: Binding<Set<Selectable>>
    private let allowSearch: Bool

    public init(title: String, options: [Selectable], optionToString: @escaping (Selectable) -> String, selected: Binding<Set<Selectable>>, allowSearch: Bool = false) {
        self.init(title: LocalizedStringKey(title), options: options, optionToString: optionToString, selected: selected, allowSearch: allowSearch)
    }

    public init(title: LocalizedStringKey, options: [Selectable], optionToString: @escaping (Selectable) -> String, selected: Binding<Set<Selectable>>, allowSearch: Bool = false) {
        self.title = title
        self.options = options
        self.optionToString = optionToString
        self.selected = selected
        self.allowSearch = allowSearch
    }

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
                        HStack(alignment: .top) {
                            Text("\u{2022}")
                            Text(optionToString(option))
                        }
                        .font(.subheadline)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func multiSelectionView() -> some View {
        MultipleChoiceSelectionView(title: title, options: options, optionToString: optionToString, selected: selected, allowSearch: allowSearch)
    }
}

struct MultipleChoiceSelectionView<Selectable: Identifiable & Hashable>: View {
    let title: LocalizedStringKey
    let options: [Selectable]
    @State var filteredOptions: [Selectable]
    let optionToString: (Selectable) -> String
    @Binding var selected: Set<Selectable>
    @State var allowSearch: Bool
    @State var searchText: String = ""

    init(title: LocalizedStringKey, options: [Selectable], optionToString: @escaping (Selectable) -> String, selected: Binding<Set<Selectable>>, allowSearch: Bool) {
        self.title = title
        self.options = options
        filteredOptions = options
        self.optionToString = optionToString
        _selected = selected
        _allowSearch = State(initialValue: allowSearch)
    }

    var body: some View {
        List {
            ForEach(filteredOptions) { selectable in
                Button(action: {
                    toggleSelection(selectable: selectable)
                }) {
                    HStack {
                        Text(optionToString(selectable))
                            .foregroundColor(.primary)
                        Spacer()

                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.accentColor)
                            .opacity(selected.contains(where: { $0.id == selectable.id }) ? 1 : 0)
                    }
                }
                .tag(selectable.id)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(title)
        .searchable(
            text: $searchText,
            isPresented: $allowSearch,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search"
        )
        .onChange(of: searchText) { _, searchText in
            if searchText.isBlank {
                filteredOptions = options
            } else {
                filteredOptions = options.filter { optionToString($0).uppercased().contains(searchText.uppercased()) }
            }
        }
    }

    private func toggleSelection(selectable: Selectable) {
        if let existingIndex = selected.firstIndex(where: { $0.id == selectable.id }) {
            selected.remove(at: existingIndex)
        } else {
            selected.insert(selectable)
        }
    }
}
