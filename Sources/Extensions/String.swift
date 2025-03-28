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

// MARK: - Error

extension String: Error {}

// MARK: - String

extension String: Identifiable {
    public var id: String { self }
}

public extension String {
    var isNotEmpty: Bool {
        !isEmpty
    }

    var isBlank: Bool {
        trimmed().isEmpty
    }

    var isNotBlank: Bool {
        !isBlank
    }

    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func orNullIfEmpty() -> String? {
        let trimmed = trimmed()
        return trimmed.isEmpty ? nil : trimmed
    }

    func toArray<T: Decodable>() -> [T] {
        do {
            if let data = data(using: .utf8) {
                return try JSONDecoder().decode([T].self, from: data)
            }
        } catch {
            print(error)
        }
        return []
    }

    func toSet<T: Decodable>() -> Set<T> {
        Set(toArray())
    }

    var lastPathComponent: String {
        if let range = range(of: "/", options: .backwards) {
            return String(self[range.upperBound...])
        }
        return self
    }

    func take(_ numberOfElements: Int) -> String {
        String(prefix(numberOfElements))
    }

    func tail(_ numberOfElements: Int) -> String {
        String(suffix(numberOfElements))
    }

    func matches(_ pattern: String) -> Bool {
        range(of: pattern, options: .regularExpression) != nil
    }
}

// MARK: - Optional String

public extension String? {
    func orEmpty() -> String {
        self ?? ""
    }

    var isEmpty: Bool {
        switch self {
        case let .some(wrapped):
            wrapped.isEmpty
        case .none:
            true
        }
    }

    var isNotEmpty: Bool {
        switch self {
        case let .some(wrapped):
            !wrapped.isEmpty
        case .none:
            false
        }
    }

    func contains(_ string: String) -> Bool {
        switch self {
        case let .some(wrapped):
            !wrapped.contains(string)
        case .none:
            false
        }
    }
}
