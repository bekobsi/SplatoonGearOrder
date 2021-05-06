//
//  FetchIksm_session.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/04/24.
//  Copyright © 2021 原直也. All rights reserved.
//

import Foundation
import RxSwift
import SplatNet2

protocol Iksm_sessionRepository {
    func update() -> Single<String>
}

final class SplatNet2Iksm_sessionRepository: Iksm_sessionRepository {
    func update() -> Single<String> {
        return Single.create { singleEvent in
            let session_token = UserDefaults.standard.string(forKey: "session_token") ?? ""
            do {
                let iksm_session = try SplatNet2.genIksmSession(session_token)["iksm_session"].stringValue
                singleEvent(.success(iksm_session))
            } catch {
                singleEvent(.failure(error))
            }
            return Disposables.create()
        }
    }
}
