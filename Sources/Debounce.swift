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

class Debounce<T> {
    private var timeInterval: TimeInterval
    private let callback: (T) -> Void
    private var timer: Timer?
    private var value: T?

    init(_ timeInterval: TimeInterval, callback: @escaping (T) -> Void) {
        self.timeInterval = timeInterval
        self.callback = callback
    }

    func call(_ t: T) {
        DispatchQueue.main.async {
            if self.timeInterval == 0 {
                self.callback(t)
            } else {
                self.value = t
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.timerFired(sender:)), userInfo: nil, repeats: false)
            }
        }
    }

    @objc
    private func timerFired(sender _: Any) {
        guard let value
        else { return }

        callback(value)
    }
}

extension Debounce where T == Void {
    func call() {
        call(())
    }
}
