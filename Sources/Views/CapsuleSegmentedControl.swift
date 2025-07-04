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

public struct CapsuleSegmentedControl<Item: Identifiable & Equatable>: View {
    let items: [Item]
    @Binding var selection: Item
    let accentColor: Color
    let title: (Item) -> String
    let titleFont: Font

    public init(items: [Item], selection: Binding<Item>, accentColor: Color = .accentColor, title: @escaping (Item) -> String, titleFont: Font = .footnote) {
        self.items = items
        _selection = selection
        self.accentColor = accentColor
        self.title = title
        self.titleFont = titleFont
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                Button(action: {
                    selection = item
                }, label: {
                    Text(title(item))
                        .font(titleFont)
                        .foregroundColor(selection == item ? .white : accentColor)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(selection == item ? accentColor : Color.clear)
                })
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .background(Capsule().stroke(accentColor, lineWidth: 2))
        .clipShape(Capsule())
    }
}

#Preview {
    @Previewable @State var dayPeriod: DayPeriod = .pm
    CapsuleSegmentedControl(
        items: DayPeriod.allCases,
        selection: $dayPeriod,
        title: { $0.title }
    )
    .frame(width: 80)
}
