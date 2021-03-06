//
//  CreateNintendoLoginPageURL.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/01/17.
//  Copyright © 2021 原直也. All rights reserved.
//

import CryptoKit
import Foundation

class CreateNintendoLoginPageURL {
    // ランダム文字列生成
    func randomStringCreate(createLength: Int) -> String {
        let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var createRadomString = [""]
        var RandomString = ""

        var i = 0

        while i < createLength {
            let randomAlpha = Int.random(in: 0 ..< 62)
            let fromIdx = str.index(str.startIndex, offsetBy: randomAlpha)
            let toIdx = str.index(str.endIndex, offsetBy: randomAlpha - 62)
            createRadomString.append(String(str[fromIdx ... toIdx]))
            i += 1
        }

        RandomString = createRadomString.joined()
        return RandomString
    }

    // 任天堂アカウントログイン画面URL生成
//    func urlselfEncode() -> String {
    ////        let auth_state = randomStringCreate(createLength: 50, numberPullOut: false)
//        let auth_state = randomStringCreate(createLength: 36).data(using: .utf8)?.base64EncodedString()
//        let authCodeVerifier = randomStringCreate(createLength: 43).data(using: .utf8)
//        let auth_cv_hash = SHA256.hash(data: authCodeVerifier!)
//        let auth_code_challenge = auth_cv_hash.data
//        var paramata = [""]
//
//        paramata = ["https://accounts.nintendo.com/connect/1.0.0/authorize?", "state=", auth_state!, "&redirect_uri=", "npf71b963c1b7b6d119://auth&", "client_id=", "71b963c1b7b6d119&", "scope=", "openid%20user%20user.birthday%20user.mii%20user.screenName&", "response_type=", "session_token_code", "&session_token_code_challenge=", authCodeVerifier, "&session_token_code_challenge_method", "=S256", "&theme", "=login_form"]
//        let NintendoLoginPageURL = paramata.joined()
//        return NintendoLoginPageURL
//    }
}
