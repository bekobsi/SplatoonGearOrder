//
//  ItemOrderPresnter.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/05/21.
//  Copyright © 2021 原直也. All rights reserved.
//

import Foundation

protocol ItemOrderPresenterInput {}

protocol ItemOrderPresenterOutput: AnyObject {}

final class ItemOrderPresenter: ItemOrderPresenterInput {
    private weak var view: ItemOrderPresenterOutput!

    init(view: ItemOrderPresenterOutput) {
        self.view = view
    }
}
