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

/// ACL情報を表す構造体です。
public struct NCMBACL: CustomStringConvertible {
    /// すべてに該当するキー名称です。
    public static let ACL_PUBLIC: String = "*"
    static let PREFIX_ROLE: String = "role:"

    private var acl: [String: NCMBAccessControlValue]

    /// 初期設定状態のACLです。
    public static var `default`: NCMBACL {
        var acl = NCMBACL.empty
        acl.put(key: NCMBACL.ACL_PUBLIC, readable: true, writable: true)
        return acl
    }

    /// 何も設定されていないACLです。
    public static var empty: NCMBACL {
        let object: [String: Any] = [:]
        return NCMBACL(object: object)
    }

    /// ACLを追加します
    ///
    /// - Parameter key: 対象となるキー
    /// - Parameter readable: 対象となるキーの読取権限を許可する場合は `true` 、許可しない場合は `false`
    /// - Parameter writable: 対象となるキーの書込権限を許可する場合は `true` 、許可しない場合は `false`
    public mutating func put(key: String, readable: Bool, writable: Bool) {
        acl[key] = NCMBAccessControlValue(read: readable, write: writable)
    }

    /// ACLを削除します
    ///
    /// - Parameter key: 対象となるキー
    public mutating func remove(key: String) {
        acl[key] = nil
    }

    init(object: Any) {
        var acl: [String: NCMBAccessControlValue] = [:]
        if let aclDictionary = object as? [String: Any] {
            for key in aclDictionary.keys {
                if let value = NCMBAccessControlValue.convert(acl: aclDictionary[key]) {
                    acl[key] = value
                }
            }
        }
        self.acl = acl
    }

    public func getReadable(key: String) -> Bool? {
        if let value = acl[key] {
            return value.readable
        }
        return nil
    }

    public func getWritable(key: String) -> Bool? {
        if let value = acl[key] {
            return value.writable
        }
        return nil
    }

    func toObject() -> [String: [String: Bool]] {
        var object: [String: [String: Bool]] = [:]
        for (key, value) in acl {
            object[key] = value.toObject()
        }
        return object
    }

    public var description: String {
        var outputArray: [String] = []

        let sortedKeys = Array(acl.keys).sorted(by:<)
        for key in sortedKeys {
            if let value: NCMBAccessControlValue = acl[key] {
                outputArray.append("\"\(key)\"=\(value)")
            }
        }

        let outputString = "{\(outputArray.joined(separator: ","))}"
        return outputString
    }
}

/// キーに対するアクセスコントロールを管理するクラスです。
private struct NCMBAccessControlValue: CustomStringConvertible {
    private var read: Bool
    private var write: Bool
    private static let FIELD_READ = "read"
    private static let FIELD_WRITE = "write"

    init() {
        read = true
        write = true
    }

    init(read: Bool, write: Bool) {
        self.read = read
        self.write = write
    }

    var readable: Bool {
        get {
            return read
        }
        set {
            read = newValue
        }
    }

    var writable: Bool {
        get {
            return write
        }
        set {
            write = newValue
        }
    }

    static func convert(acl: Any?) -> NCMBAccessControlValue? {
        var read: Bool = false
        var write: Bool = false
        if let acl = acl as? [String: Bool] {
            if let aclread = acl[FIELD_READ] {
                read = aclread
            }
            if let aclwrite = acl[FIELD_WRITE] {
                write = aclwrite
            }
            return NCMBAccessControlValue(read: read, write: write)
        }
        return nil
    }

    func toObject() -> [String: Bool] {
        var object: [String: Bool] = [:]
        if readable {
            object[NCMBAccessControlValue.FIELD_READ] = true
        }
        if writable {
            object[NCMBAccessControlValue.FIELD_WRITE] = true
        }
        return object
    }

    public var description: String {
        return "(read=\(readable),write=\(writable))"
    }
}
