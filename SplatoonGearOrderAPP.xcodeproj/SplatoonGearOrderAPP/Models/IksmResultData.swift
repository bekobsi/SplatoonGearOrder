//
//  IksmResultData.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/11/08.
//  Copyright © 2020 原直也. All rights reserved.
//

import Foundation

class iksmData : Decodable {
    let results: [results]
}

//各戦績
class results : Decodable {
    let battle_number: String
    let rule: name
    let stage: name
    let udemae: name?
    let estimate_x_power: Double?
    let my_team_result: name
    let player_result: player_result
}

//プレイヤーの戦績
class player_result : Decodable {
    let assist_count: Int
    let death_count: Int
    let kill_count: Int
    let special_count: Int
    let player : player
}

//プレイヤーの情報
class player : Decodable {
    let nickname: String
    let weapon: weapon
}

//武器の情報
class weapon : Decodable {
    let name: String
    let special: name
    let sub: name
}

class name : Decodable {
    let name: String
}
