//
//  OrderButtonTebleViewCell.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/05/21.
//  Copyright © 2021 原直也. All rights reserved.
//

import UIKit

class OrderButtonTebleViewCell: UITableViewCell {
    @IBOutlet var orderButton: UIButton!

    func orderButtonSetUp() {
        orderButton.titleLabel?.font = UIFont(name: "Optima-ExtraBlack", size: 17)
        orderButton.layer.cornerRadius = orderButton.frame.size.width * 0.1
    }
}
