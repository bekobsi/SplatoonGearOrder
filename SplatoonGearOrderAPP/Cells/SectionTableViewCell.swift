//
//  SectionTableViewCell.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/03/11.
//  Copyright © 2021 原直也. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {
    @IBOutlet var sectionNameLabel: UILabel!
    var sectionName: String? {
        didSet {
            sectionNameLabel.text = sectionName
        }
    }
}
