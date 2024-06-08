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

import Combine
import Foundation

public extension Publisher {
    func tryAwaitMap<T>(_ transform: @escaping (Self.Output) async throws -> T) -> Publishers.FlatMap<Future<T, Error>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    do {
                        let result = try await transform(value)
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }

    func sink(receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) async -> Void), receiveValue: @escaping ((Self.Output) async -> Void)) -> AnyCancellable {
        sink { completion in
            Task { await receiveCompletion(completion) }
        } receiveValue: { value in
            Task { await receiveValue(value) }
        }
    }

    func main() -> Publishers.ReceiveOn<Self, DispatchQueue> {
        receive(on: DispatchQueue.main)
    }

    func sink(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        sink(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                logDebug(error)
            }
        }, receiveValue: receiveValue)
    }

    func sinkMain(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        main().sink(receiveValue: receiveValue)
    }

    func logDebugError() -> Publishers.HandleEvents<Self> {
        handleEvents(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                logDebug(error)
            }
        })
    }
}

public extension Publisher where Self.Failure == Never {
    func sink(receiveValue: @escaping ((Self.Output) async -> Void)) -> AnyCancellable {
        sink { value in
            Task { await receiveValue(value) }
        }
    }
}
