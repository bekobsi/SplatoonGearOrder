//
//  GesoTownTableViewCell.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2021/02/01.
//  Copyright © 2021 原直也. All rights reserved.
//

import SDWebImage
import UIKit

class GesoTownTableViewCell: UITableViewCell {
    let timeTypeConversion = TimeTypeConversion()
    @IBOutlet var GearImageView: UIImageView!
    @IBOutlet var GearNameLabel: UILabel!
    @IBOutlet var GearOrderDeadlineLabel: UILabel!
    @IBOutlet var GearFeeLabel: UILabel!
    @IBOutlet var MainGearPowerImage: UIImageView!
    @IBOutlet var FrequentSkill_ImageView: UIImageView!
    var gesoTownInfo: merchandises? {
        didSet {
            let GearOrderDeadlineTime = timeTypeConversion.UNIXtimeToUTCtime(UNIXtime: gesoTownInfo?.end_time ?? 0)
            GearNameLabel.text = gesoTownInfo?.gear.name
            GearFeeLabel.text = gesoTownInfo?.price.description
            GearFeeLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15)

            GearOrderDeadlineLabel.text = GearOrderDeadlineTime
            let nintendoURL = "https://app.splatoon2.nintendo.net"
            guard let gearImageViewURL = gesoTownInfo?.gear.thumbnail else { return }
            GearImageView.sd_setImage(with: URL(string: nintendoURL + gearImageViewURL))
            MainGearPowerImage.sd_setImage(with: URL(string: "https://app.splatoon2.nintendo.net\(gesoTownInfo?.skill.image ?? "")"))
            MainGearPowerImage.layer.cornerRadius = MainGearPowerImage.frame.size.width * 0.5
            FrequentSkill_ImageView.sd_setImage(with: URL(string: "https://app.splatoon2.nintendo.net\(gesoTownInfo?.gear.brand.frequent_skill.image ?? "")"))
            FrequentSkill_ImageView.layer.cornerRadius = FrequentSkill_ImageView.frame.size.width * 0.5
        }
    }
}
