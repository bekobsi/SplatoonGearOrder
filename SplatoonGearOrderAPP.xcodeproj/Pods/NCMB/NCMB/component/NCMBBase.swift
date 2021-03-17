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

/// nifcloud mobile backend データストアを操作するためのクラスです。
public class NCMBBase: CustomStringConvertible {
    static let FIELDNAME_OBJECTID: String = "objectId"
    static let FIELDNAME_ACL: String = "acl"
    static let FIELDNAME_CREATEDATE: String = "createDate"
    static let FIELDNAME_UPDATEDATE: String = "updateDate"
    private static let IGNORED_KEYS: Set<String> = [
        FIELDNAME_OBJECTID,
        FIELDNAME_ACL,
        FIELDNAME_CREATEDATE,
        FIELDNAME_UPDATEDATE,
    ]

    /// データストアのクラス名です。
    let className: String
    private var _fields: [String: Any]
    private var _modifiedFieldKeys: Set<String> = []

    /// オブジェクトIDです。
    /// 未設定の場合は `nil` です。
    public var objectId: String? {
        get {
            return _fields[NCMBBase.FIELDNAME_OBJECTID] as? String
        }
        set {
            _fields[NCMBBase.FIELDNAME_OBJECTID] = newValue
        }
    }

    /// ACLです。
    /// 未設定の場合は `nil` です。
    public var acl: NCMBACL? {
        get {
            let object = _fields[NCMBBase.FIELDNAME_ACL]
            if let object = object {
                return NCMBACL(object: object)
            }
            return nil
        }
        set {
            if let newValue: NCMBACL = newValue {
                _fields[NCMBBase.FIELDNAME_ACL] = newValue.toObject()
            } else {
                _fields[NCMBBase.FIELDNAME_ACL] = nil
            }
            _modifiedFieldKeys.insert(NCMBBase.FIELDNAME_ACL)
        }
    }

    /// フィールド内容です。
    ///
    /// - Parameter field: フィールド名
    public subscript<T>(field: String) -> T? {
        get {
            if let value: Any = _fields[field] {
                if let fieldValue = NCMBFieldTypeConverter.convertToFieldValue(object: value) {
                    if let fieldValue = fieldValue as? T {
                        return fieldValue
                    }
                }
                return value as? T
            }
            return nil
        }
        set {
            if let newValue: T = newValue {
                if let object = NCMBFieldTypeConverter.converToObject(value: newValue) {
                    setFieldValue(field: field, value: object)
                } else {
                    setFieldValue(field: field, value: newValue)
                }
            } else {
                removeField(field: field)
            }
        }
    }

    /// イニシャライズです。
    ///
    /// - Parameter className: データストアのクラス名。
    /// - Parameter fields: フィールド内容
    /// - Parameter modifiedFieldKeys: 更新フィールド名一覧
    required init(className: String, fields: [String: Any], modifiedFieldKeys: Set<String> = []) {
        self.className = className
        _fields = fields
        _modifiedFieldKeys = modifiedFieldKeys
    }

    /// イニシャライズです。
    ///
    /// - Parameter className: データストアのクラス名
    init(className: String = "") {
        self.className = className
        _fields = [:]
    }

    /// クラスインスタンスをコピーして返します。
    var copy: NCMBBase {
        let base = NCMBBase(className: className, fields: fields, modifiedFieldKeys: modifiedFieldKeys)
        return base
    }

    /// フィールド内容の一覧を返します。
    var fields: [String: Any] {
        let fields = _fields
        return fields
    }

    /// 更新対象となるフィールドのフィールド名一覧を返します。
    ///
    /// - Returns: 更新対象となるフィールドのフィールド名一覧
    var modifiedFieldKeys: Set<String> {
        let modifiedFieldKeys = _modifiedFieldKeys
        return modifiedFieldKeys
    }

    /// フィールドの内容を削除します。
    ///
    /// - Parameter field: フィールド名
    func removeField(field: String) {
        if !isIgnoredKey(field: field) {
            _fields[field] = nil
            _modifiedFieldKeys.insert(field)
        }
    }

    /// 設定されている内容から更新が必要かを判定し、更新処理が必要な場合は `true` 、それ以外では `false` を返します。
    var needUpdate: Bool {
        return _modifiedFieldKeys.count > 0
    }

    /// 指定されたフィールドに値を設定します。
    ///
    /// - Parameter field: フィールド名
    /// - Parameter value: 設定する値
    private func setFieldValue(field: String, value: Any?) {
        if !isIgnoredKey(field: field) {
            _fields[field] = value
            _modifiedFieldKeys.insert(field)
        }
    }

    /// レスポンス内容をフィールドに反映させます。
    ///
    /// - Parameter response: レスポンス
    func reflectResponse(response: NCMBResponse) {
        for key in response.contents.keys {
            _fields[key] = response.contents[key]
        }
        removeAllModifiedFieldKeys()
    }

    /// フィールドの内容をJson形式にして返します。
    ///
    /// - Returns: フィールド内容のJson。
    func toJson() throws -> Data? {
        do {
            return try NCMBJsonConverter.convertToJson(_fields)
        } catch {
            throw NCMBInvalidRequestError.invalidBodyJsonValue
        }
    }

    /// 登録対象フィールドの内容をJson形式にして返します。
    ///
    /// - Returns: 登録フィールド対象内容のJson。
    func getPostFieldsToJson() throws -> Data? {
        var fields: [String: Any] = _fields
        fields[NCMBBase.FIELDNAME_OBJECTID] = nil
        fields[NCMBBase.FIELDNAME_CREATEDATE] = nil
        fields[NCMBBase.FIELDNAME_UPDATEDATE] = nil
        do {
            return try NCMBJsonConverter.convertToJson(fields)
        } catch {
            throw NCMBInvalidRequestError.invalidBodyJsonValue
        }
    }

    /// 更新フィールド内容をJson形式にて返します。
    ///
    /// - Returns: 更新フィールド内容のJson。
    func getModifiedToJson() throws -> Data? {
        var fields: [String: Any?] = [:]
        for key in _modifiedFieldKeys {
            fields[key] = _fields[key]
        }
        do {
            return try NCMBJsonConverter.convertToJson(fields)
        } catch {
            throw NCMBInvalidRequestError.invalidBodyJsonValue
        }
    }

    /// フィールド内容をすべて消去します。
    func removeAllFields() {
        _fields.removeAll()
    }

    /// 更新フィールド内容を消去します。
    func removeAllModifiedFieldKeys() {
        _modifiedFieldKeys.removeAll()
    }

    /// ユーザーが設定可能なフィールドであるかを判定します。
    ///
    /// - Parameter field: フィールド名
    /// - Returns: ユーザーが設定可能なフィールドの場合は `true` 、それ以外では `false` 。
    func isIgnoredKey(field: String) -> Bool {
        return NCMBBase.IGNORED_KEYS.contains(field)
    }

    public var description: String {
        var outputString = "{"
        let optionalClassName: String? = className
        if let className = optionalClassName {
            outputString += "className=\(className)"
        } else {
            outputString += "className=nil"
        }

        if let objectId = _fields[NCMBBase.FIELDNAME_OBJECTID] as? String {
            outputString += ",objectId=\(objectId)"
        } else {
            outputString += ",objectId=nil"
        }

        let sortedKeys = Array(_fields.keys).sorted(by:<)
        for key in sortedKeys {
            if NCMBBase.IGNORED_KEYS.contains(key) {
                continue
            }

            if let value = _fields[key] {
                outputString += ",\(key)=\(value)"
            }
        }
        outputString += "}"

        return outputString
    }
}
