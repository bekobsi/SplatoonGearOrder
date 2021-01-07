//
//  UIColor-Extention.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/01.
//  Copyright © 2020 原直也. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
