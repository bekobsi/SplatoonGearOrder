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
    @IBOutlet var gearImageView: UIImageView!
    @IBOutlet var gearNameLabel: UILabel!
    @IBOutlet var gearOrderDeadlineLabel: UILabel!
    @IBOutlet var gearFeeLabel: UILabel!
    @IBOutlet var mainGearPowerImage: UIImageView!
    @IBOutlet var frequentSkill_ImageView: UIImageView!
    var gesoTownInfo: merchandises? {
        didSet {
            let gearOrderDeadlineTime = timeTypeConversion.UNIXtimeToUTCtime(UNIXtime: gesoTownInfo?.end_time ?? 0)
            gearNameLabel.text = gesoTownInfo?.gear.name
            gearFeeLabel.text = gesoTownInfo?.price.description
            gearFeeLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15)
            gearOrderDeadlineLabel.text = gearOrderDeadlineTime

            let nintendoURL = "https://app.splatoon2.nintendo.net"
            guard let gearImageURL = gesoTownInfo?.gear.thumbnail else { return }
            guard let gearSkillImageURL = gesoTownInfo?.skill.image else { return }
            guard let gearFrequentSkillImageURL = gesoTownInfo?.gear.brand.frequent_skill.image else { return }

            gearImageView.sd_setImage(with: URL(string: nintendoURL + gearImageURL))
            mainGearPowerImage.sd_setImage(with: URL(string: nintendoURL + gearSkillImageURL))
            mainGearPowerImage.layer.cornerRadius = mainGearPowerImage.frame.size.width * 0.5
            frequentSkill_ImageView.sd_setImage(with: URL(string: nintendoURL + gearFrequentSkillImageURL))
            frequentSkill_ImageView.layer.cornerRadius = frequentSkill_ImageView.frame.size.width * 0.5
        }
    }

    var orderedInfo: ordered_info? {
        didSet {
            let nintendoURL = "https://app.splatoon2.nintendo.net"
            guard let orderedItemURL = orderedInfo?.gear.thumbnail else { return }
            guard let orderedItemSkillImageURL = orderedInfo?.skill.image else { return }
            guard let orderedFrequentSkillImageURL = orderedInfo?.gear.brand.frequent_skill.image else { return }

            gearImageView.sd_setImage(with: URL(string: nintendoURL + orderedItemURL))
            mainGearPowerImage.sd_setImage(with: URL(string: nintendoURL + orderedItemSkillImageURL))
            mainGearPowerImage.layer.cornerRadius = mainGearPowerImage.frame.size.width * 0.5
            frequentSkill_ImageView.sd_setImage(with: URL(string: nintendoURL + orderedFrequentSkillImageURL))
            frequentSkill_ImageView.layer.cornerRadius = frequentSkill_ImageView.frame.size.width * 0.5

            gearNameLabel.text = orderedInfo?.gear.name
            gearFeeLabel.text = orderedInfo?.price.description
            gearFeeLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15)
            gearOrderDeadlineLabel.text = ""
        }
    }
}
