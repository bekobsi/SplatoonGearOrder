//
//  FetchStageInfo.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/04/20.
//  Copyright © 2021 原直也. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

protocol StageRepositry {
    func get() -> Single<Stage>
}

final class AlamofireStageRepository: StageRepositry {
    func get() -> Single<Stage> {
        return Single.create { SingleEvent in
            let url = "https://spla2.yuu26.com/schedule"
            let request = AF.request(url)

            request.responseJSON { response in
                do {
                    guard let data = response.data else { return }
                    let stageInfo = try JSONDecoder().decode(Stage.self, from: data)
                    SingleEvent(.success(stageInfo))
                } catch {
                    SingleEvent(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
