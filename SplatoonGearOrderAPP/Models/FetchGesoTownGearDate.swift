//
//  FetchGesoTownGearDate.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/04/26.
//  Copyright © 2021 原直也. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

protocol GesoTownGearRepository {
    func get() -> Single<iksmGesoTownData>
}

final class AlamofireGesoTownGearRrepository: GesoTownGearRepository {
    var iksm_session = UserDefaults.standard.string(forKey: "iksm_session") ?? ""
    let now = Date(timeIntervalSinceNow: 60 * 60 * 9)

    func get() -> Single<iksmGesoTownData> {
        return Single.create { singleEvent in
            let url = URL(string: "https://app.splatoon2.nintendo.net/api/onlineshop/merchandises")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("Iksm_session", forHTTPHeaderField: self.iksm_session)
            urlRequest.httpShouldHandleCookies = true
            AF.request(urlRequest).responseJSON { response in
                do {
                    guard let json = response.data else { return }
                    let gesoTownGearDate = try JSONDecoder().decode(iksmGesoTownData.self, from: json)
                    UserDefaults.standard.set(self.now, forKey: "lastUseDate")
                    singleEvent(.success(gesoTownGearDate))
                } catch {
                    singleEvent(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
