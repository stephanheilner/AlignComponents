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

public struct CapsuleMenuStyle: MenuStyle {
    let tintColor: Color
    var selected: Bool

    public init(tintColor: Color = .accentColor, selected: Bool = false) {
        self.tintColor = tintColor
        self.selected = selected
    }

    public func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .font(.body.weight(.medium))
            .padding(.horizontal, 22)
            .padding(.vertical, 11)
            .foregroundColor(selected ? Color.white : tintColor)
            .background(Capsule().fill(selected ? tintColor : Color.clear))
            .overlay(
                Capsule()
                    .stroke(selected ? Color.white : tintColor, lineWidth: 1)
            )
            .animation(.easeOut(duration: 0.1), value: selected)
    }
}

public extension MenuStyle where Self == CapsuleMenuStyle {
    static var capsule: CapsuleMenuStyle { CapsuleMenuStyle() }
}
