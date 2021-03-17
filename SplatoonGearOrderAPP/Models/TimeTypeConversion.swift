//
//  TimeTypeConversion.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/02/25.
//  Copyright © 2021 原直也. All rights reserved.
//

import Foundation

class TimeTypeConversion {
    func UNIXtimeToUTCtime(UNIXtime: Double) -> String {
        let date = Date()
        let presentUNIXtime = Double(date.timeIntervalSince1970)
        let salesTime: Double = UNIXtime
        let limitTime: Double = salesTime - presentUNIXtime
        let limitTimeInterval = TimeInterval(limitTime)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: limitTimeInterval)!
    }
}
