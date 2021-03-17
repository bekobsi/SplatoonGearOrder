/*
 Copyright 2019 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

class NCMBLocalFileManagerFactory {
    private static let shared = NCMBLocalFileManagerFactory()
    private var _manager: NCMBLocalFileManagerProtocol

    private init() {
        #if os(iOS)
            _manager = NCMBLocalFileManager()
        #else
            _manager = DummyLocalFileManager()
        #endif
    }

    class func setDummy() {
        shared._manager = DummyLocalFileManager()
    }

    class func getInstance() -> NCMBLocalFileManagerProtocol {
        return shared._manager
    }

    class func setInstance(manager: NCMBLocalFileManagerProtocol) {
        shared._manager = manager
    }

    private class DummyLocalFileManager: NCMBLocalFileManagerProtocol {
        func loadFromFile(target _: NCMBLocalFileType) -> Data? { return nil }
        func saveToFile(data _: Data, target _: NCMBLocalFileType) {}
        func deleteFile(target _: NCMBLocalFileType) {}
        init() {}
    }

    private class NCMBLocalFileManager: NCMBLocalFileManagerProtocol {
        let manager: FileManager
        let baseUrl: URL

        init() {
            manager = FileManager.default
            let documentDir: URL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            baseUrl = documentDir.appendingPathComponent("NCMB")
        }

        func loadFromFile(target: NCMBLocalFileType) -> Data? {
            let url: URL = target.getURL(base: baseUrl)
            if !manager.fileExists(atPath: url.relativePath) {
                return nil
            }
            do {
                return try Data(contentsOf: url)
            } catch {
                NSLog("NCMB: Failed to acquire local file with \(target.message) : \(error)")
            }
            return nil
        }

        func saveToFile(data: Data, target: NCMBLocalFileType) {
            do {
                try manager.createDirectory(at: baseUrl, withIntermediateDirectories: true, attributes: [:])
                try data.write(to: target.getURL(base: baseUrl), options: [])
            } catch {
                NSLog("NCMB: Failed to save local file with \(target.message) : \(error)")
            }
        }

        func deleteFile(target: NCMBLocalFileType) {
            do {
                try manager.removeItem(at: target.getURL(base: baseUrl))
            } catch {
                NSLog("NCMB: Failed to delete local file with \(target.message) : \(error)")
            }
        }
    }
}
