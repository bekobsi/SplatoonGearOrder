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
    func get(iksm_session: String, now: Date) -> Single<iksmGesoTownData>
}

final class AlamofireGesoTownGearRrepository: GesoTownGearRepository {
    func get(iksm_session: String, now: Date) -> Single<iksmGesoTownData> {
        return Single.create { singleEvent in
            let url = URL(string: "https://app.splatoon2.nintendo.net/api/onlineshop/merchandises")!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("Iksm_session", forHTTPHeaderField: iksm_session)
            urlRequest.httpShouldHandleCookies = true
            AF.request(urlRequest).responseJSON { response in
                do {
                    guard let json = response.data else { return }
                    let gesoTownGearDate = try JSONDecoder().decode(iksmGesoTownData.self, from: json)
                    UserDefaults.standard.set(now, forKey: "lastUseDate")
                    singleEvent(.success(gesoTownGearDate))
                } catch {
                    singleEvent(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
