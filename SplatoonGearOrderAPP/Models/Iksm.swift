//
//  Iksm.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/07.
//  Copyright © 2020 原直也. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

let semaphore = DispatchSemaphore(value: 0)
let queue = DispatchQueue.global(qos: .utility)
let ver = String(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)

class Iksm {
    class func get_session_token(session_token_code: String, verifier: String) throws -> String {
        let url = "https://accounts.nintendo.com/connect/1.0.0/api/session_token"
        let app_head: HTTPHeaders = [
            "User-Agent": "com.nintendo.znca/1.6.1.2 Android",
            "Accept-Language": "en-US",
            "Accept": "application/json",
            "Host": "accounts.nintendo.com",
            "Connecton": "Keep-Alive",
            "Accept-Encoding": "gzip",
        ]
        let body = [
            "client_id": "71b963c1b7b6d119",
            "session_token_code": session_token_code,
            "session_token_code_verifier": verifier,
        ]
        var json: JSON?
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: app_head)
            .validate(contentType: ["application/json"])
            .responseJSON(queue: queue) { response in
                switch response.result {
                case let .success(value):
                    json = JSON(value)
                case .failure:
                    break
                }
                semaphore.signal()
            }
        semaphore.wait()
        if json == nil {
//            throw APIError.Response(1000, "Login Step(session_token).")
            print("jsonデータの取得に失敗しました")
        }
        return json!["session_token"].stringValue
    }

    class func get_access_token(session_token: String, userLang: String) throws -> JSON {
        let url = "https://accounts.nintendo.com/connect/1.0.0/api/token"
        let app_head: HTTPHeaders = [
            "Host": "accounts.nintendo.com",
            "Accept-Encoding": "gzip",
            "Content-Type": "application/json; charset=utf-8",
            "Accept-Language": userLang,
            "Content-Length": "439",
            "Accept": "application/json",
            "Connecton": "Keep-Alive",
            "User-Agent": "com.nintendo.znca/1.6.1.2 Android",
        ]
        let body = [
            "client_id": "71b963c1b7b6d119",
            "session_token": session_token,
            "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer-session-token",
        ]
        var json: JSON?
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: app_head)
            .validate(contentType: ["application/json"])
            .responseJSON(queue: queue) { response in
                switch response.result {
                case let .success(value):
                    json = JSON(value)
                case .failure:
                    break
                }
                semaphore.signal()
            }
        semaphore.wait()
        if json == nil {
//             throw APIError.Response(1001, "Login Step(access_token).") // Error Handler
            print("アクセストークンの取得に失敗しました")
        }
        return json!
    }

    class func get_userinfo(access_token: String, userLang: String) throws -> JSON {
        let url = "https://api.accounts.nintendo.com/2.0.0/users/me"
        let app_head: HTTPHeaders = [
            "User-Agent": "OnlineLounge/1.6.1.2 NASDKAPI Android",
            "Accept-Language": userLang,
            "Accept": "application/json",
            "Authorization": "Bearer " + access_token,
            "Host": "api.accounts.nintendo.com",
            "Connection": "Keep-Alive",
            "Accept-Encoding": "gzip",
        ]
        var json: JSON?
        AF.request(url, method: .get, headers: app_head)
            .validate(contentType: ["application/json"])
            .responseJSON(queue: queue) { response in
                switch response.result {
                case let .success(value):
                    json = JSON(value)
                case .failure:
                    break
                }
                semaphore.signal()
            }
        semaphore.wait()
        if json == nil {
//            throw APIError.Response(1002, "Account Step(user_info).") // Error Handler
        }
        return json!
    }

    class func get_splatoon_token(userLang: String, user_info: JSON, flapg_nso: JSON) throws -> String {
        let url = "https://api-lp1.znc.srv.nintendo.net/v1/Account/Login"
        let app_head: HTTPHeaders = [
            "Host": "api-lp1.znc.srv.nintendo.net",
            "Accept-Language": userLang,
            "User-Agent": "com.nintendo.znca/1.6.1.2 (Android/7.1.2)",
            "Accept": "application/json",
            "X-ProductVersion": "1.6.1.2",
            "Content-Type": "application/json; charset=utf-8",
            "Connection": "Keep-Alive",
            "Authorization": "Bearer",
            "X-Platform": "Android",
            "Accept-Encoding": "gzip",
        ]
        let body: JSON = [
            "f": flapg_nso["f"],
            "naIdToken": flapg_nso["p1"],
            "timestamp": flapg_nso["p2"],
            "requestId": flapg_nso["p3"],
            "naCountry": user_info["country"],
            "naBirthday": user_info["birthday"],
            "language": user_info["language"],
        ]
        let app_body: Dictionary = ["parameter": body.dictionaryObject!]

        var json = JSON()
        AF.request(url, method: .post, parameters: app_body, encoding: JSONEncoding.default, headers: app_head)
            .validate(contentType: ["application/json"])
            .responseJSON(queue: queue) { response in
                switch response.result {
                case let .success(value):
                    json = JSON(value)
                case .failure:
                    break
                }
                semaphore.signal()
            }
        semaphore.wait()

        // Error Checking
        switch json["status"].intValue {
        case 9403:
//            throw APIError.Response(9403, "Invalid Token.")
            return "Invalid Token."
        case 9406:
//            throw APIError.Response(9406, "Unauthorized.")
            return "Unauthorized"
        case 9427:
//            throw APIError.Response(9427, "Upgrade Required.")
            return "Upgrade Required"
        default:
            return json["result"]["webApiServerCredential"]["accessToken"].stringValue
        }
    }

    class func get_splatoon_access_token(splatoon_token: String, flapg_app: JSON) throws -> String {
        let url = "https://api-lp1.znc.srv.nintendo.net/v2/Game/GetWebServiceToken"
        let app_head: HTTPHeaders = [
            "Host": "api-lp1.znc.srv.nintendo.net",
            "User-Agent": "com.nintendo.znca/1.6.1.2 Android",
            "Accept": "application/json",
            "X-ProductVersion": "1.6.1.2",
            "Content-Type": "application/json; charset=utf-8",
            "Connection": "Keep-Alive",
            "Authorization": "Bearer " + splatoon_token,
            "X-Platform": "Android",
            "Accept-Encoding": "gzip",
        ]
        let body: JSON = [
            "id": 5_741_031_244_955_648,
            "f": flapg_app["f"],
            "registrationToken": flapg_app["p1"],
            "timestamp": flapg_app["p2"],
            "requestId": flapg_app["p3"],
        ]
        let app_body = ["parameter": body.dictionaryObject!]
        var json: JSON?
        AF.request(url, method: .post, parameters: app_body, encoding: JSONEncoding.default, headers: app_head)
            .validate(contentType: ["application/json"])
            .responseJSON(queue: queue) { response in
                switch response.result {
                case let .success(value):
                    json = JSON(value)
                case .failure:
                    break
                }
                semaphore.signal()
            }
        semaphore.wait()
        if json == nil {
//            throw APIError.Response(1003, "Login Step(Splatoon2).") // Error Handler
            print("Login Step(Splatoon2).")
        }
        return json!["result"]["accessToken"].stringValue
    }

    class func get_cookie(session_token: String, userLang: String) throws -> String {
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let guid = String(CFUUIDCreateString(nil, CFUUIDCreate(nil)))

        // Get Access Token
        let id_response = try get_access_token(session_token: session_token, userLang: userLang)
        let access_token = id_response["access_token"].stringValue

        // Get User information
        let user_info = try get_userinfo(access_token: access_token, userLang: userLang)

        // Get flapg parameters
        let flapg_nso = try call_flapg_api(id_token: access_token, guid: guid, timestamp: timestamp, type: "nso")

        // Get Splatoon token
        let splatoon_token = try get_splatoon_token(userLang: userLang, user_info: user_info, flapg_nso: flapg_nso)
        let flapg_app = try call_flapg_api(id_token: splatoon_token, guid: guid, timestamp: timestamp, type: "app")

        // Get Splatoon access token
        let splatoon_access_token = try get_splatoon_access_token(splatoon_token: splatoon_token, flapg_app: flapg_app)

        // Get cookie
        let url = "https://app.splatoon2.nintendo.net/?lang=" + userLang
        let app_head: HTTPHeaders = [
            "Host": "app.splatoon2.nintendo.net",
            "X-IsAppAnalyticsOptedIn": "false",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Encoding": "gzip,deflate",
            "X-GameWebToken": splatoon_access_token,
            "Accept-Language": userLang,
            "X-IsAnalyticsOptedIn": "false",
            "Connection": "keep-alive",
            "DNT": "0",
            "User-Agent": "Salmonia for iOS/" + ver,
            "X-Requested-With": "com.nintendo.znca",
        ]

//        let app_head: HTTPHeaders = [
//            "Host" :                    "app.splatoon2.nintendo.net",
//            "Accept" :                  "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
//            "X-GameWebToken" :          splatoon_access_token,
//            "X-IsAnalyticsOptedIn" :    "true",
//            "DNT" :                     "0",
//            "X-IsAnalyticsOptedIn" :    "true",
//            "User-Agent" :              "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
//            "Accept-Language" :         userLang,
//            "Accept-Encoding" :         "gzip,deflate, br"
//        ]
        var iksm_session: String?

        AF.request(url, method: .get, headers: app_head)
            .response(queue: queue) { response in
                let cookie = HTTPCookie.cookies(withResponseHeaderFields: response.response?.allHeaderFields as! [String: String], for: (response.response?.url!)!)
                print("cookie", cookie)
                iksm_session = cookie.first!.value
                semaphore.signal()
            }
        semaphore.wait()
        if iksm_session == nil {
//            throw APIError.Response(1004, "Auth Step(iksm_session)")
            print("Auth Step(iksm_session)")
        }
        return iksm_session!
    }

    class func call_flapg_api(id_token: String, guid: String, timestamp: Int, type: String) throws -> JSON {
        var json: JSON?
        let url = "https://flapg.com/ika2/api/login?public"
        let api_app_head: HTTPHeaders = [
            "x-token": id_token,
            "x-time": String(timestamp),
            "x-guid": guid,
            "x-hash": try get_hash_from_s2s_api(id_token: id_token, timestamp: timestamp),
            "x-ver": "3",
            "x-iid": type,
            "User-Agent": "Salmonia for iOS/" + ver,
        ]
        AF.request(url, method: .get, headers: api_app_head)
            .validate(contentType: ["application/json"])
            .responseJSON(queue: queue) { response in
                switch response.result {
                case let .success(value):
                    json = JSON(value)
                case let .failure(value):
                    debugPrint(value)
                }
                semaphore.signal()
            }
        semaphore.wait()
        if json == nil {
//            throw APIError.Response(2001, "Auth Step(flapg API).") // Error Handler
            print("Auth Step(flapg API)")
        }
        return json!["result"]
    }

    class func get_hash_from_s2s_api(id_token: String, timestamp: Int) throws -> String {
        let url = "https://elifessler.com/s2s/api/gen2"
        let api_app_head: HTTPHeaders = [
            "User-Agent": "Salmonia for iOS/" + ver,
        ]
        let api_body = [
            "naIdToken": id_token,
            "timestamp": String(timestamp),
        ]
        var json: JSON?
        AF.request(url, method: .post, parameters: api_body, headers: api_app_head)
            .validate(contentType: ["application/json"])
            .responseJSON(queue: queue) { response in
                switch response.result {
                case let .success(value):
                    json = JSON(value)
                case .failure:
                    break
                }
                semaphore.signal()
            }
        semaphore.wait()
        if json == nil {
//            throw APIError.Response(2000, "Auth Step(s2s API).") // Error Handler
            print("Auth Step(s2s API).")
        }
        return json!["hash"].stringValue
    }
}
