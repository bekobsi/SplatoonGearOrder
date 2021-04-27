//
//  Gesotown.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/02/21.
//  Copyright © 2021 原直也. All rights reserved.
//

import Foundation

struct iksmGesoTownData: Decodable {
    let ordered_info: ordered_info
    let merchandises: [merchandises]
}

// 現在頼んでいるギアの詳細
struct ordered_info: Decodable {
    let skill: skill
    let gear: gear
    let price: Int
}

// 現在GesoTownで頼めるギア一覧
struct merchandises: Decodable {
    let skill: skill
    let gear: gear
    let price: Int
    let end_time: Double
}

// 細かいギア情報
struct gear: Decodable {
    // ギア画像
    let thumbnail: String
    let rarity: Int
    let brand: brand
    let name: String
}

// ブランドの詳細
struct brand: Decodable {
    let image: String
    let name: String
    let frequent_skill: frequent_skill
}

// ブランドごとの上がりやすいギアパワー
struct frequent_skill: Decodable {
    let image: String
    let name: String
}

// スキルの情報
struct skill: Decodable {
    let name: String
    let image: String
}
