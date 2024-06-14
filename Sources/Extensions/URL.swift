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

public extension URL {
    /// Append parameters to the existing query string. Well understood if the parameters are unique. This will leave existing parameters and simply add in the new name and value pairs provided in the parameters argument.
    ///
    /// - Parameter parameters: A dictionary of new names and value pairs to add to the query string.
    /// - Returns: Returns a valid URL if adding the parameters does not cause problems.
    func appendingQueryStringParameters(_ parameters: [String: String]) -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        else { return self }

        // Code below borrowed from Swifter.Swift
        var items = urlComponents.queryItems ?? []
        items += parameters.map { URLQueryItem(name: $0, value: $1) }
        urlComponents.queryItems = items

        return urlComponents.url ?? self
    }

    var resumeDataFileUrl: URL {
        deletingPathExtension().appendingPathExtension("resume")
    }
}
