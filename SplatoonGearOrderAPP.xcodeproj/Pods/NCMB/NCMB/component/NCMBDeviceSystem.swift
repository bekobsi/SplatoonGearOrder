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

#if os(iOS)
    import UIKit
#endif

class NCMBDeviceSystem {
    private static let shared = NCMBDeviceSystem()
    private var _osType: String
    private var _osVersion: String

    private init() {
        #if os(OSX)
            _osType = "osx"
            let version: OperatingSystemVersion = ProcessInfo().operatingSystemVersion
            _osVersion = String(format: "%d.%d.%d", version.majorVersion, version.minorVersion, version.patchVersion)
        #elseif os(iOS)
            _osType = "ios"
            _osVersion = UIDevice.current.systemVersion
            print(_osVersion)
        #elseif os(Linux)
            _osType = "linux"
            _osVersion = ""
        #endif
    }

    class var osType: String {
        return getInstance()._osType
    }

    class var osVersion: String {
        return getInstance()._osType + "-" + getInstance()._osVersion
    }

    private class func getInstance() -> NCMBDeviceSystem {
        return shared
    }
}
