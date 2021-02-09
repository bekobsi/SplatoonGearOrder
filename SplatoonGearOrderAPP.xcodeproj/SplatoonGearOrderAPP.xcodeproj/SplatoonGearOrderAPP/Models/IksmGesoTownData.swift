//
//  IksmGesoTownData.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/11/08.
//  Copyright © 2020 原直也. All rights reserved.
//

import Foundation

class iksmGesoTownData: Decodable {
    let ordered_info: ordered_info
    let merchandises: [merchandises]
}

// 現在頼んでいるギアの詳細
class ordered_info: Decodable {
    let gear: gear
    let price: Int
    let skill: skill
}

// 現在GesoTownで頼めるギア一覧
class merchandises: Decodable {
    let skill: skill
    let gear: gear
    let price: Int
}

// 細かいギア情報
class gear: Decodable {
    let thumbnail: String
    let rarity: Int
    let brand: brand
    let name: String
}

// ブランドの詳細
class brand: Decodable {
    let image: String
    let name: String
    let frequent_skill: frequent_skill
}

// ブランドごとの上がりやすいギアパワー
class frequent_skill: Decodable {
    let image: String
    let name: String
}

// スキルの情報
class skill: Decodable {
    let name: String
    let image: String
}
