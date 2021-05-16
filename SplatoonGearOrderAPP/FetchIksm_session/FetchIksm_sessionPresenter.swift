//
//  FetchIksm_sessionPresenter.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/05/11.
//  Copyright © 2021 原直也. All rights reserved.
//

import Foundation

protocol FetchIksm_sessionPresenterInput {
    func test()
}

protocol FetchIksm_sessionPresenterOutput: AnyObject {
    func test2()
}

final class FetchIksm_sessionPresenter: FetchIksm_sessionPresenterInput {
    private weak var view: FetchIksm_sessionPresenterOutput!

    init(view: FetchIksm_sessionPresenterOutput) {
        self.view = view
    }

    func test() {}
}
