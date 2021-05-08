//
//  JapanTimeFromUnixTime.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/05/08.
//  Copyright © 2021 原直也. All rights reserved.
//

import Foundation

func japanTimeFromUnixTime(start: String, end: String) -> String {
    let month = start[start.index(start.startIndex, offsetBy: 5) ..< start.index(start.startIndex, offsetBy: 7)]
    let day = start[start.index(start.startIndex, offsetBy: 8) ..< start.index(start.startIndex, offsetBy: 10)]
    let startTime = start[start.index(start.startIndex, offsetBy: 11) ..< start.index(start.startIndex, offsetBy: 16)]
    let endTime = end[end.index(end.startIndex, offsetBy: 11) ..< end.index(end.startIndex, offsetBy: 16)]

    return "\(month)月\(day)日 \(startTime)~\(endTime)"
}
