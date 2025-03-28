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

public extension FileManager {
    private func directory(for directory: FileManager.SearchPathDirectory) -> URL {
        guard let url = urls(for: directory, in: .userDomainMask).last
        else { fatalError("Unable to access \(directory) directory") }
        return url
    }

    func documentDirectory() -> URL {
        directory(for: .documentDirectory)
    }

    func libraryDirectory() -> URL {
        directory(for: .libraryDirectory)
    }

    func applicationSupportDirectory() -> URL {
        directory(for: .applicationSupportDirectory)
    }

    func cachesDirectory() -> URL {
        directory(for: .cachesDirectory)
    }

    func privateDocumentsDirectory() -> URL {
        let directory = libraryDirectory().appendingPathComponent("PrivateDocuments")
        silentlyCreateDirectory(at: directory)
        return directory
    }

    func databaseDirectory() -> URL {
        let directory = privateDocumentsDirectory().appendingPathComponent("Database")
        silentlyCreateDirectory(at: directory)
        return directory
    }

    func imageCacheDirectory() -> URL {
        let directory = cachesDirectory().appendingPathComponent("Images")
        silentlyCreateDirectory(at: directory)
        return directory
    }

    func silentlyRemoveItem(at url: URL) {
        try? removeItem(at: url)
    }

    func silentlyCreateDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool = true, attributes: [FileAttributeKey: Any]? = nil) {
        try? createDirectory(at: url, withIntermediateDirectories: createIntermediates, attributes: attributes)
    }

    func uniqueTempDirectory() -> URL {
        let directory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString)
        FileManager.default.silentlyCreateDirectory(at: directory)
        return directory
    }

    func uniqueTempFile() -> URL {
        URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString).appendingPathExtension("tmp")
    }
}

extension URLResourceValues {
    static let isExcludedFromBackupResourceValues: URLResourceValues = {
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        return resourceValues
    }()
}
