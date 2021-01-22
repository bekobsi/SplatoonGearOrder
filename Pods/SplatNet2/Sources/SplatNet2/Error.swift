//
//  File.swift
//
//
//  Created by devonly on 2020-10-12.
//

import Foundation

enum APPError: Error {
    case unknown
    case upgrade
    case unauthorized
    case forbidden
    case badrequest
    case requests
    case unavailable
    case method
    case invalid
    case expired
}

extension APPError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badrequest:
            return "Wrong Request"
        case .expired:
            return "Iksm Session is Unauthorized/Expired"
        case .forbidden:
            return "Insecure Connection/Disallowed User Agent"
        case .invalid:
            return "Invalid Splatoon Token"
        case .method:
            return "Method Not Allowed"
        case .unauthorized:
            return "Unauthorized Splatoon Token"
        case .upgrade:
            return "Nintendo API Changed"
        case .requests:
            return "Too Many Requests"
        case .unavailable:
            return "Server is Unavailable"
        case .unknown:
            return "Unknown Error"
        }
    }
}

extension APPError: CustomNSError {
    var errorCode: Int {
        switch self {
        case .badrequest:
            return 9400
        case .expired:
            return 9403
        case .forbidden:
            return 9403
        case .invalid:
            return 9403
        case .method:
            return 9405
        case .unauthorized:
            return 9406
        case .upgrade:
            return 9427
        case .requests:
            return 9429
        case .unavailable:
            return 9503
        case .unknown:
            return 9999
        }
    }
}
