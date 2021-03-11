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
            guard let gearImageURL = gesoTownInfo?.gear.thumbnail else { return }
            guard let gearSkillImageURL = gesoTownInfo?.skill.image else { return }
            guard let gearFrequentSkillImageURL = gesoTownInfo?.gear.brand.frequent_skill.image else { return }

            GearImageView.sd_setImage(with: URL(string: nintendoURL + gearImageURL))
            MainGearPowerImage.sd_setImage(with: URL(string: nintendoURL + gearSkillImageURL))
            MainGearPowerImage.layer.cornerRadius = MainGearPowerImage.frame.size.width * 0.5
            FrequentSkill_ImageView.sd_setImage(with: URL(string: nintendoURL + gearFrequentSkillImageURL))
            FrequentSkill_ImageView.layer.cornerRadius = FrequentSkill_ImageView.frame.size.width * 0.5
        }
    }

    var orderedInfo: ordered_info? {
        didSet {
            let nintendoURL = "https://app.splatoon2.nintendo.net"
            guard let orderedItemURL = orderedInfo?.gear.thumbnail else { return }
            guard let orderedItemSkillImageURL = orderedInfo?.skill.image else { return }
            guard let orderedFrequentSkillImageURL = orderedInfo?.gear.brand.frequent_skill.image else { return }

            GearImageView.sd_setImage(with: URL(string: nintendoURL + orderedItemURL))
            MainGearPowerImage.sd_setImage(with: URL(string: nintendoURL + orderedItemSkillImageURL))
            MainGearPowerImage.layer.cornerRadius = MainGearPowerImage.frame.size.width * 0.5
            FrequentSkill_ImageView.sd_setImage(with: URL(string: nintendoURL + orderedFrequentSkillImageURL))
            FrequentSkill_ImageView.layer.cornerRadius = FrequentSkill_ImageView.frame.size.width * 0.5

            GearNameLabel.text = orderedInfo?.gear.name
            GearFeeLabel.text = orderedInfo?.price.description
            GearFeeLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15)
            GearOrderDeadlineLabel.text = ""
        }
    }
}
