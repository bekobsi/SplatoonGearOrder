//
//  Session_token_codeurlConversionToIksm_sessionAndSession_token.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/05/16.
//  Copyright © 2021 原直也. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift
import SplatNet2
import SwiftyJSON

protocol Session_token_codeURLRepository {
    func get(_ session_token_codeURL: String) -> Single<Bool>
}

class Session_token_codeURLConversion: Session_token_codeURLRepository {
    private var session_token_code = ""
    private var response = JSON()
    private let now = Date(timeIntervalSinceNow: 60 * 60 * 9)

    func session_token_codeurlConversionToSession_token_code(session_token_codeURL: String) {
        var count = 0
        while session_token_codeURL.prefix(count).contains("session_token_code=") == false {
            count += 1
        }
        session_token_code = String(session_token_codeURL.dropFirst(count))
        count = 0
        while session_token_codeURL.dropLast(count).contains("&state=") == true {
            count += 1
        }
        session_token_code = String(session_token_code.dropLast(count + 6))
    }

    func get(_ session_token_codeURL: String) -> Single<Bool> {
        return Single.create { SingleEvent -> Disposable in
            if session_token_codeURL.contains("session_token_code=") == true {
                print("session_token_code取得に成功しました。:", session_token_codeURL)
                do {
                    self.session_token_codeurlConversionToSession_token_code(session_token_codeURL: session_token_codeURL)
                    let auth_code_verifer = "anvnw6SdIPmSUUG7DcMRqD8ak4aZXKNPdKM9nFszxUQ"
                    print("session_token_codeが生成されました:", self.session_token_code)
                    print("auth_code_verifer:", auth_code_verifer)
                    self.response = try SplatNet2.getSessionToken(self.session_token_code, auth_code_verifer)
                    let session_token = self.response["session_token"].stringValue

                    let iksm_session = try SplatNet2.genIksmSession(session_token)["iksm_session"].stringValue
                    print("iksm_session", iksm_session)

                    UserDefaults.standard.set(session_token, forKey: "session_token")
                    UserDefaults.standard.set(iksm_session, forKey: "iksm_session")
                    UserDefaults.standard.set(self.now, forKey: "lastUseDate")
                    SingleEvent(.success(true))
                } catch {
                    print("catchが呼ばれました", error)
                    SingleEvent(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
