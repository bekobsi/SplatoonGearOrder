import Alamofire
import Foundation
import SwiftyJSON

public class SplatNet2 {
    static let ver: String = "0.1.5"

    public class func getSessionToken(_ session_token_code: String, _ session_token_code_verifier: String, _: String = "Salmonia/0.1.5") throws -> JSON {
        let url = "https://accounts.nintendo.com/connect/1.0.0/api/session_token"
        let header: HTTPHeaders = [
            "User-Agent": "Salmonia/\(ver) @tkgling",
        ]
        let body = [
            "client_id": "71b963c1b7b6d119",
            "session_token_code": session_token_code,
            "session_token_code_verifier": session_token_code_verifier,
        ]

        let response: JSON = try SplatNet2.request(url, headers: header, parameters: body, encoding: JSONEncoding.default)
        return response
    }

    class func getAccessToken(_ session_token: String) throws -> JSON {
        let url = "https://accounts.nintendo.com/connect/1.0.0/api/token"
        let header: HTTPHeaders = [
            "User-Agent": "Salmonia/\(ver) @tkgling",
        ]
        let body = [
            "client_id": "71b963c1b7b6d119",
            "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer-session-token",
            "session_token": session_token,
        ]

        let response: JSON = try SplatNet2.request(url, headers: header, parameters: body, encoding: JSONEncoding.default)
        return response
    }

    class func callS2SAPI(_ access_token: String, timestamp: Int, _ ua: String = "Salmonia/0.1.5 @tkgling") throws -> JSON {
        let url = "https://elifessler.com/s2s/api/gen2"
        let header: HTTPHeaders = [
            "User-Agent": "\(ua)",
        ]
        let body = [
            "naIdToken": access_token,
            "timestamp": String(timestamp),
        ]
        let response = try SplatNet2.request(url, headers: header, parameters: body, encoding: URLEncoding.default)
        return response
    }

    class func callFlapgAPI(_ access_token: String, _ type: String, _ ua: String = "Salmonia/0.1.5 @tkgling") throws -> JSON {
        let timestamp = Int(NSDate().timeIntervalSince1970)

        var response = try SplatNet2.callS2SAPI(access_token, timestamp: timestamp, ua)
        let hash = response["hash"].stringValue

        let url = "https://flapg.com/ika2/api/login?public"
        let header: HTTPHeaders = [
            "x-token": access_token,
            "x-time": String(timestamp),
            "x-guid": "037239ef-1914-43dc-815d-178aae7d8934",
            "x-hash": hash,
            "x-ver": "3",
            "x-iid": type,
            "User-Agent": "\(ua)",
        ]

        response = try SplatNet2.request(url, method: .get, headers: header)
        return response
    }

    class func getSplatoonToken(_ result: JSON, version: String = "1.9.0") throws -> JSON {
        let url = "https://api-lp1.znc.srv.nintendo.net/v1/Account/Login"
        let header: HTTPHeaders = [
            "X-ProductVersion": "\(version)",
            "X-Platform": "Android",
        ]
        let body = [
            "parameter": [
                "f": result["f"].stringValue,
                "naIdToken": result["p1"].stringValue,
                "timestamp": result["p2"].stringValue,
                "requestId": result["p3"].stringValue,
                "naCountry": "JP",
                "naBirthday": "1990-01-01",
                "language": "ja-JP",
            ],
        ]

        let response: JSON = try SplatNet2.request(url, headers: header, parameters: body, encoding: JSONEncoding.default)
        return response
    }

    class func getSplatoonAccessToken(_ result: JSON, _ splatoon_token: String) throws -> JSON {
        let url = "https://api-lp1.znc.srv.nintendo.net/v2/Game/GetWebServiceToken"
        let header: HTTPHeaders = [
            "X-Platform": "Android",
            "Authorization": "Bearer \(splatoon_token)",
        ]
        let body = [
            "parameter": [
                "id": 5_741_031_244_955_648,
                "f": result["f"].stringValue,
                "registrationToken": result["p1"].stringValue,
                "timestamp": result["p2"].stringValue,
                "requestId": result["p3"].stringValue,
            ],
        ]

        let response: JSON = try SplatNet2.request(url, headers: header, parameters: body, encoding: JSONEncoding.default)
        return response
    }

    class func getIksmSession(_ splatoon_access_token: String) throws -> JSON {
        let header: HTTPHeaders = [
            "Cookie": "iksm_session=",
            "X-GameWebToken": splatoon_access_token,
        ]
        var request = URLRequest(url: URL(string: "https://app.splatoon2.nintendo.net/")!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = header.dictionary

        let response: JSON = try SplatNet2.request(request)
        return response
    }

    public class func genIksmSession(_ session_token: String, version: String = "1.9.0", _ ua: String = "Salmonia/0.1.5 @tkgling") throws -> JSON {
        var response = JSON()

        response = try SplatNet2.getAccessToken(session_token)
        let access_token = response["access_token"].stringValue
        response = try SplatNet2.callFlapgAPI(access_token, "nso", ua)
        let flapg_nso = response["result"]
        response = try SplatNet2.getSplatoonToken(flapg_nso, version: version)
        let splatoon_token = response["result"]["webApiServerCredential"]["accessToken"].stringValue
        let nickname = response["result"]["user"]["name"].stringValue
        let imageUri = response["result"]["user"]["imageUri"].stringValue
        response = try SplatNet2.callFlapgAPI(splatoon_token, "app", ua)
        let flapg_app = response["result"]
        response = try SplatNet2.getSplatoonAccessToken(flapg_app, splatoon_token)
        let splatoon_access_token = response["result"]["accessToken"].stringValue
        response = try SplatNet2.getIksmSession(splatoon_access_token)
        let iksm_session = response["iksm_session"].stringValue
        let nsaid = response["nsaid"].stringValue

        response = JSON(["user": ["nickname": nickname, "thumbnail_url": imageUri], "iksm_session": iksm_session, "nsaid": nsaid])
        return response
    }

    public class func isValid(iksm_session: String) -> Bool {
        let url = "https://app.splatoon2.nintendo.net/api/coop_results"
        do {
            _ = try SplatNet2.get(url, iksm_session: iksm_session)
            return true
        } catch {
            return false
        }
    }

    public class func getPlayerNickName(_ nsaid: String, iksm_session: String) throws -> JSON {
        let url = "https://app.splatoon2.nintendo.net/api/nickname_and_icon?id=\(nsaid)"
        let response = try SplatNet2.get(url, iksm_session: iksm_session)
        return response
    }

    public class func getPlayerNickName(_ nsaid: [String], iksm_session: String) throws -> JSON {
        let query = nsaid.map { "id=\($0)&" }.reduce("", +)
        let url = "https://app.splatoon2.nintendo.net/api/nickname_and_icon?\(query)"
        let response = try SplatNet2.get(url, iksm_session: iksm_session)
        return response
    }

    public class func getResult(job_id: Int, iksm_session: String) throws -> JSON {
        let url = "https://app.splatoon2.nintendo.net/api/coop_results/\(job_id)"
        let response: JSON = try SplatNet2.get(url, iksm_session: iksm_session)
        return response
    }

    public class func getSummary(iksm_session: String) throws -> JSON {
        let url = "https://app.splatoon2.nintendo.net/api/coop_results"
        let response: JSON = try SplatNet2.get(url, iksm_session: iksm_session)
        return response
    }

    class func request(_ request: URLRequest) throws -> JSON {
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)

        var cookie: String?
        var data_nsa_id: String?
        AF.request(request).responseString(queue: queue) { response in
            switch response.result {
            case let .success(value):
                data_nsa_id = value.capture(pattern: "data-nsa-id=([/0-f/]{16})", group: 1)
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: response.response?.allHeaderFields as! [String: String], for: (response.response?.url!)!)
                cookie = cookies.first!.value
            case .failure:
                break
            }
            semaphore.signal()
        }

        semaphore.wait()
        guard let iksm_session = cookie else { throw APPError.expired }
        guard let nsaid = data_nsa_id else { throw APPError.expired }
        return JSON(["iksm_session": iksm_session, "nsaid": nsaid])
    }

    class func get(_ url: String, iksm_session: String) throws -> JSON {
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)

        let header: HTTPHeaders = [
            "cookie": "iksm_session=\(iksm_session)",
        ]

        var statusCode: Int? = 200
        var json: JSON?
        AF.request(url, method: .get, headers: header)
//            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON(queue: queue) { response in
                switch response.result {
                case let .success(value):
                    statusCode = response.response?.statusCode
                    json = JSON(value)
                case let .failure(error):
                    print(error)
                }
                semaphore.signal()
            }
        semaphore.wait()

        guard let code = statusCode else { throw APPError.unknown }
        guard let response = json else { throw APPError.unknown }

        // Status Code Error
        switch code {
        case 400:
            throw APPError.badrequest
        case 403:
            throw APPError.expired
        case 405:
            throw APPError.method
        case 429:
            throw APPError.requests
        case 503:
            throw APPError.unavailable
        default:
            break
        }

        return response
    }

    class func request(_ url: URLConvertible, method: HTTPMethod = .post, headers: HTTPHeaders?, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default) throws -> JSON {
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)

        var statusCode: Int? = 200
        var json: JSON?
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
//            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON(queue: queue) { response in
                switch response.result {
                case let .success(value):
                    statusCode = response.response?.statusCode
                    json = JSON(value)
                case let .failure(error):
                    print(error)
                }
                semaphore.signal()
            }
        semaphore.wait()

        guard let code = statusCode else { throw APPError.unknown }
        guard let response = json else { throw APPError.unknown }

        // Status Code Error
        switch code {
        case 400:
            throw APPError.badrequest
        case 403:
            throw APPError.forbidden
        case 405:
            throw APPError.method
        case 429:
            throw APPError.requests
        case 503:
            throw APPError.unavailable
        default:
            break
        }

        // Response Error
        switch response["status"].intValue {
        case 9400:
            throw APPError.badrequest
        case 9403:
            throw APPError.invalid
        case 9406:
            throw APPError.unauthorized
        case 9427:
            throw APPError.upgrade
        default:
            return response
        }
    }
}

extension String {
    func capture(pattern: String, group: Int) -> String? {
        let result = capture(pattern: pattern, group: [group])
        return result.isEmpty ? nil : result[0]
    }

    func capture(pattern: String, group: [Int]) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }
        guard let matched = regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) else {
            return []
        }
        return group.map { group -> String in
            (self as NSString).substring(with: matched.range(at: group))
        }
    }
}
