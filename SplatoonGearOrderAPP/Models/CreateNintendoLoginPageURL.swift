//
//  CreateNintendoLoginPageURL.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/01/17.
//  Copyright © 2021 原直也. All rights reserved.
//

import Foundation

class CreateNintendoLoginPageURL {
    // ランダム文字列生成
    func randomStringCreate(createLength: Int) -> String {
        let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var createRadomString = [""]
        var test = ""

        var i = 0
        while i < createLength {
            let randomAlpha = Int.random(in: 0 ..< 62)
            let fromIdx = str.index(str.startIndex, offsetBy: randomAlpha)
            let toIdx = str.index(str.endIndex, offsetBy: randomAlpha - 62)
            createRadomString.append(String(str[fromIdx ... toIdx]))
            i += 1
        }
        test = createRadomString.joined()
        return test
    }

    // 任天堂アカウントログイン画面URL生成
    func urlselfEncode() -> String {
        let authState = randomStringCreate(createLength: 50)
        let authCodeVerifier = randomStringCreate(createLength: 43)
        var paramata = [""]

        paramata = ["https://accounts.nintendo.com/connect/1.0.0/authorize?", "state=", authState, "&redirect_uri=", "npf71b963c1b7b6d119://auth&", "client_id=", "71b963c1b7b6d119&", "scope=", "openid%20user%20user.birthday%20user.mii%20user.screenName&", "response_type=", "session_token_code", "&session_token_code_challenge=", authCodeVerifier, "&session_token_code_challenge_method", "=S256", "&theme", "=login_form", " HTTP/2.0"]
        let NintendoLoginPageURL = paramata.joined()
        return NintendoLoginPageURL
    }
}
