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

public extension View {
    func hud(hudMessage: Binding<HUDMessage?>) -> some View {
        modifier(HUDViewModifier(hudMessage: hudMessage))
    }
}

public struct HUDViewModifier: ViewModifier {
    @Binding var hudMessage: HUDMessage?
    @State private var workItem: DispatchWorkItem?

    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainHUDView()
                        .offset(y: 32)
                }.animation(.spring(), value: hudMessage)
            )
            .onChange(of: hudMessage) { _ in
                showHUD()
            }
    }

    @ViewBuilder
    func mainHUDView() -> some View {
        if let hudMessage {
            HUD {
                HUDMessageView(message: hudMessage)
            }
        }
    }

    private func showHUD() {
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()

        workItem?.cancel()

        let task = DispatchWorkItem {
            dismissHUD()
        }

        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
    }

    private func dismissHUD() {
        withAnimation {
            hudMessage = nil
        }

        workItem?.cancel()
        workItem = nil
    }
}
