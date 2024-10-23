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
    var optionImage: ((Selectable) -> Image?)?
    var selected: Binding<Selectable>
    var showValueAsTitle: Bool = false

    public init(title: LocalizedStringKey, options: [Selectable], optionToString: @escaping (Selectable) -> String, optionImage: ((Selectable) -> Image?)? = nil, selected: Binding<Selectable>, showValueAsTitle: Bool = false) {
        self.title = title
        self.options = options
        self.optionToString = optionToString
        self.optionImage = optionImage
        self.selected = selected
        self.showValueAsTitle = showValueAsTitle
    }

    public init(title: String, options: [Selectable], optionToString: @escaping (Selectable) -> String, optionImage: ((Selectable) -> Image?)? = nil, selected: Binding<Selectable>, showValueAsTitle: Bool = false) {
        self.init(title: LocalizedStringKey(title), options: options, optionToString: optionToString, optionImage: optionImage, selected: selected, showValueAsTitle: showValueAsTitle)
    }

    public var body: some View {
        NavigationLink(destination: LazyView { selectionView() }) {
            if showValueAsTitle {
                Text(optionToString(selected.wrappedValue))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            } else {
                HStack {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)

                    Spacer()

                    Text(optionToString(selected.wrappedValue))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }

    @ViewBuilder
    private func selectionView() -> some View {
        SingleChoiceSelectionView(title: title, options: options, optionToString: optionToString, selected: selected)
    }
}

private struct SingleChoiceSelectionView<Selectable: Identifiable & Hashable>: View {
    @Environment(\.presentationMode) private var presentationMode

    let title: LocalizedStringKey
    let options: [Selectable]
    @State var filteredOptions: [Selectable]
    let optionToString: (Selectable) -> String
    var optionImage: ((Selectable) -> Image?)?
    @Binding var selected: Selectable
    @State var searchText: String = ""

    init(title: LocalizedStringKey, options: [Selectable], optionToString: @escaping (Selectable) -> String, optionImage: ((Selectable) -> Image?)? = nil, selected: Binding<Selectable>) {
        self.title = title
        self.options = options
        filteredOptions = options
        self.optionToString = optionToString
        self.optionImage = optionImage
        _selected = selected
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

                        if let image = optionImage?(selectable) {
                            image.padding(.leading, 10)
                        }

                        Spacer()

                        if selected.id == selectable.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .tag(selectable.id)
            }
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search"
        )
        .onChange(of: searchText) { searchText in
            if searchText.isBlank {
                filteredOptions = options
            } else {
                filteredOptions = options.filter { optionToString($0).uppercased().contains(searchText.uppercased()) }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(title)
    }

    private func toggleSelection(selectable: Selectable) {
        selected = selectable
        presentationMode.wrappedValue.dismiss()
    }
}
