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

struct NCMBFileService: NCMBRequestServiceProtocol {
    static let REQUEST_TIMEINTERVAL: TimeInterval = 120.0
    static let BOUNDARY = "_NCMBProjectBoundary"
    static let LOAD_CONTENT_TYPE_STATEMENT = "multipart/form-data; boundary=\(BOUNDARY)"
    static let BLOCK_BEGIN_DELIMTER: Data = toData(string: "--\(BOUNDARY)\r\n")
    static let BLOCK_END_DELIMTER: Data = toData(string: "--\(BOUNDARY)--\r\n\r\n")

    var apiType: NCMBApiType {
        return .files
    }

    func getSubpath(object _: NCMBBase, objectId _: String?) -> [String] {
        return []
    }

    func find(query: NCMBQuery<NCMBFile>, callback: @escaping (NCMBResult<NCMBResponse>) -> Void) {
        let request: NCMBRequest
        request = createGetRequest(query: query)
        let executor: NCMBRequestExecutorProtocol = NCMBRequestExecutorFactory.getInstance()
        executor.exec(request: request, callback: { (result: NCMBResult<NCMBResponse>) -> Void in
            callback(result)
        })
    }

    func fetch(file: NCMBFile, callback: @escaping (NCMBResult<NCMBResponse>) -> Void) {
        let request: NCMBRequest = createGetRequest(file: file)
        let executor: NCMBRequestExecutorProtocol = NCMBRequestExecutorFactory.getInstance()
        executor.exec(request: request, callback: { (result: NCMBResult<NCMBResponse>) -> Void in
            callback(result)
        })
    }

    func save(file: NCMBFile, data: Data, callback: @escaping (NCMBResult<NCMBResponse>) -> Void) {
        let request: NCMBRequest
        do {
            request = try createPostRequest(file: file, data: data)
        } catch {
            let result = NCMBResult<NCMBResponse>.failure(error)
            callback(result)
            return
        }
        let executor: NCMBRequestExecutorProtocol = NCMBRequestExecutorFactory.getInstance()
        executor.exec(request: request, callback: { (result: NCMBResult<NCMBResponse>) -> Void in
            callback(result)
        })
    }

    func update(file: NCMBFile, callback: @escaping (NCMBResult<NCMBResponse>) -> Void) {
        let request: NCMBRequest
        do {
            request = try createPutRequest(file: file)
        } catch {
            let result = NCMBResult<NCMBResponse>.failure(error)
            callback(result)
            return
        }
        let executor: NCMBRequestExecutorProtocol = NCMBRequestExecutorFactory.getInstance()
        executor.exec(request: request, callback: { (result: NCMBResult<NCMBResponse>) -> Void in
            callback(result)
        })
    }

    func delete(file: NCMBFile, callback: @escaping (NCMBResult<NCMBResponse>) -> Void) {
        let request: NCMBRequest = createDeleteRequest(file: file)
        let executor: NCMBRequestExecutorProtocol = NCMBRequestExecutorFactory.getInstance()
        executor.exec(request: request, callback: { (result: NCMBResult<NCMBResponse>) -> Void in
            callback(result)
        })
    }

    func createGetRequest(file: NCMBFile) -> NCMBRequest {
        let request = NCMBRequest(
            apiType: apiType,
            method: NCMBHTTPMethod.get,
            subpath: [file.fileName],
            timeoutInterval: NCMBFileService.REQUEST_TIMEINTERVAL
        )
        return request
    }

    func createGetRequest(query: NCMBQuery<NCMBFile>) -> NCMBRequest {
        let request = NCMBRequest(
            apiType: apiType,
            method: NCMBHTTPMethod.get,
            subpath: [],
            queries: query.requestItems
        )
        return request
    }

    func createPostRequest(file: NCMBFile, data: Data?) throws -> NCMBRequest {
        let requestData: Data
        do {
            requestData = try createRequestData(file: file, data: data)
        } catch {
            throw error
        }
        let request = NCMBRequest(
            apiType: apiType,
            method: NCMBHTTPMethod.post,
            subpath: [file.fileName],
            contentType: NCMBFileService.LOAD_CONTENT_TYPE_STATEMENT,
            contentLength: requestData.count,
            body: requestData,
            timeoutInterval: NCMBFileService.REQUEST_TIMEINTERVAL
        )
        return request
    }

    func createPutRequest(file: NCMBFile) throws -> NCMBRequest {
        do {
            let request = NCMBRequest(
                apiType: apiType,
                method: NCMBHTTPMethod.put,
                subpath: [file.fileName],
                body: try convertACLtoJson(acl: file.acl)
            )
            return request
        } catch {
            throw error
        }
    }

    func createDeleteRequest(file: NCMBFile) -> NCMBRequest {
        let request = NCMBRequest(
            apiType: apiType,
            method: NCMBHTTPMethod.delete,
            subpath: [file.fileName]
        )
        return request
    }

    func convertACLtoJson(acl: NCMBACL?) throws -> Data? {
        if let acl = acl {
            do {
                return try NCMBJsonConverter.convertToJson(acl.toObject())
            } catch {
                throw error
            }
        }
        throw NCMBInvalidRequestError.invalidACL
    }

    func createRequestData(file: NCMBFile, data: Data?) throws -> Data {
        var result = Data()
        if let acl: NCMBACL = file.acl {
            do {
                let aclJson = try convertACLtoJson(acl: acl)
                result.append(createBodyBlock(name: "acl", filename: "acl", data: aclJson))
            } catch {
                throw error
            }
        }
        result.append(createBodyBlock(name: "file", filename: file.fileName, data: data))
        result.append(NCMBFileService.BLOCK_END_DELIMTER)
        return result
    }

    func createBodyBlock(name: String, filename: String, data: Data?) -> Data {
        var result = Data()
        result.append(NCMBFileService.BLOCK_BEGIN_DELIMTER)
        result.append(NCMBFileService.toData(string: "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n\r\n"))
        if let data = data {
            result.append(data)
        }
        result.append(NCMBFileService.toData(string: "\r\n"))
        return result
    }

    static func toData(string: String) -> Data {
        if let data: Data = string.data(using: .utf8) {
            return data
        }
        return Data()
    }
}
