//
//  Stage.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/01.
//  Copyright © 2020 原直也. All rights reserved.
//

import Foundation

struct Stage: Decodable {
    let result: StageRule
}

struct StageRule: Decodable {
    let regular: [StageInfo]
    let gachi: [StageInfo]
    let league: [StageInfo]
}

struct StageInfo: Decodable {
    let rule: String
    let maps_ex: [MapInfo]
    let start: String
    let end: String
}

struct MapInfo: Decodable {
    let id: Int
    let name: String
    let image: String
}
