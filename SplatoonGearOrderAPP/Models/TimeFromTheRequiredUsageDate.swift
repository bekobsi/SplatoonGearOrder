//
//  TimeFromTheRequiredUsageDate.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/05/09.
//  Copyright © 2021 原直也. All rights reserved.
//

import Foundation

class TimeFromTheLastUsageDate {
    func timeFromTheLastUsageDate() -> String {
        let ud = UserDefaults.standard

        guard let lastUseDate = ud.object(forKey: "lastUseDate") as? Date else {
            return "前回の利用記録がありません"
        }

        let calender = Calendar.current
        let now = Date(timeIntervalSinceNow: 60 * 60 * 9)
        let today = calender.component(.day, from: now)
        let lastUseDay = calender.component(.day, from: lastUseDate)
        if today == lastUseDay {
            return "前回利用日から日付が変わっていません"
        } else {
            return "前回利用日から日付が変わっています"
        }
    }
}
