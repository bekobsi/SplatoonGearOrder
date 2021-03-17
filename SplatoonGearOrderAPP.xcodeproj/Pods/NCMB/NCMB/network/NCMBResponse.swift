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

/// リクエストからの返却内容を保持する構造体です。
public struct NCMBResponse {
    let body: Data?
    let contents: [String: Any]
    let response: HTTPURLResponse

    init(contents: [String: Any], response: HTTPURLResponse) throws {
        self.contents = contents
        self.response = response
        do {
            body = try NCMBJsonConverter.convertToJson(contents)
        } catch {
            throw error
        }
    }

    init(body: Data?, response: URLResponse?) throws {
        self.body = body
        do {
            contents = try NCMBJsonConverter.convertToKeyValue(body)
        } catch _ {
            contents = [:]
        }
        do {
            self.response = try NCMBResponse.convertHTTPURLResponse(response: response)
        } catch {
            throw error
        }
    }

    var isError: Bool {
        if 200 ... 299 ~= response.statusCode {
            return false
        }
        return true
    }

    var apiError: NCMBApiError? {
        if !isError {
            return nil
        }
        return NCMBApiError(body: contents)
    }

    static func convertHTTPURLResponse(response: URLResponse?) throws -> HTTPURLResponse {
        if let response = response {
            let httpUrlResponse = response as? HTTPURLResponse
            if let httpUrlResponse = httpUrlResponse {
                return httpUrlResponse
            }
        }
        throw NCMBParseError.unsupportResponseHeader
    }
}
