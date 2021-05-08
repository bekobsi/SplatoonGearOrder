//
//  StageScheduleTableViewCell.swift
//  SplatoonGearOrderAPP
//
//  Created by 原直也 on 2020/09/01.
//  Copyright © 2020 原直也. All rights reserved.
//

import UIKit

class StageScheduleTableViewCell: UITableViewCell {
    @IBOutlet var cellSpaceImageView: UIImageView!
    @IBOutlet var stageOpenTimeLabel: UILabel!

    @IBOutlet var regularStageRuleLabel: UILabel!
    @IBOutlet var fastRegularStageNameLabel: UILabel!
    @IBOutlet var fastRegularStageImageView: UIImageView!
    @IBOutlet var secondRegularStageNameLabel: UILabel!
    @IBOutlet var secondRegularStageImageView: UIImageView!

    @IBOutlet var gachiStageRuleLabel: UILabel!
    @IBOutlet var fastGachiStageNameLabel: UILabel!
    @IBOutlet var fastGachiStageImageView: UIImageView!
    @IBOutlet var secondGachiStageLabel: UILabel!
    @IBOutlet var secondGachiStageImageView: UIImageView!

    @IBOutlet var leagueStageRuleLabel: UILabel!
    @IBOutlet var fastLeagueStageNameLabel: UILabel!
    @IBOutlet var fastLeagueStageImageView: UIImageView!
    @IBOutlet var secondLeagueStageNameLabel: UILabel!
    @IBOutlet var secondLeagueStageImageView: UIImageView!

    var regularStage: StageInfo? {
        didSet {
            regularStageRuleLabel.font = UIFont(name: "Optima-ExtraBlack", size: 17)
            var stageImage = UIImage(named: regularStage?.maps_ex[0].id.description ?? "1")
            fastRegularStageImageView.image = stageImage
            fastRegularStageImageView.layer.cornerRadius = 25
            fastRegularStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            fastRegularStageImageView.layer.borderWidth = 1

            stageImage = UIImage(named: regularStage?.maps_ex[1].id.description ?? "1")

            secondRegularStageImageView.image = stageImage
            secondRegularStageImageView.layer.cornerRadius = 25
            secondRegularStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            secondRegularStageImageView.layer.borderWidth = 1

            fastRegularStageNameLabel.text = regularStage?.maps_ex[0].name
            secondRegularStageNameLabel.text = regularStage?.maps_ex[1].name

            cellSpaceImageView.layer.borderWidth = 1
            cellSpaceImageView.layer.borderColor = UIColor.rgb(red: 200, green: 200, blue: 200).cgColor
            guard let start = regularStage?.start else { return }
            guard let end = regularStage?.end else { return }
            let stageOpenTime = japanTimeFromUnixTime(start: start, end: end)
            stageOpenTimeLabel.text = stageOpenTime
        }
    }

    var gachiStage: StageInfo? {
        didSet {
            gachiStageRuleLabel.font = UIFont(name: "Optima-ExtraBlack", size: 17)
            gachiStageRuleLabel.text = gachiStage?.rule

            var stageImage = UIImage(named: gachiStage?.maps_ex[0].id.description ?? "1")
            fastGachiStageImageView.image = stageImage
            fastGachiStageImageView.layer.cornerRadius = 25
            fastGachiStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            fastGachiStageImageView.layer.borderWidth = 1

            stageImage = UIImage(named: gachiStage?.maps_ex[1].id.description ?? "1")
            secondGachiStageImageView.image = stageImage
            secondGachiStageImageView.layer.cornerRadius = 25
            secondGachiStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            secondGachiStageImageView.layer.borderWidth = 1

            fastGachiStageNameLabel.text = gachiStage?.maps_ex[0].name
            secondGachiStageLabel.text = gachiStage?.maps_ex[1].name
        }
    }

    var leagueStage: StageInfo? {
        didSet {
            leagueStageRuleLabel.font = UIFont(name: "Optima-ExtraBlack", size: 17)
            leagueStageRuleLabel.text = leagueStage?.rule

            var stageImage = UIImage(named: leagueStage?.maps_ex[0].id.description ?? "1")
            fastLeagueStageImageView.image = stageImage
            fastLeagueStageImageView.layer.cornerRadius = 25
            fastLeagueStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            fastLeagueStageImageView.layer.borderWidth = 1

            stageImage = UIImage(named: leagueStage?.maps_ex[1].id.description ?? "1")
            secondLeagueStageImageView.image = stageImage
            secondLeagueStageImageView.layer.cornerRadius = 25
            secondLeagueStageImageView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
            secondLeagueStageImageView.layer.borderWidth = 1

            fastLeagueStageNameLabel.text = leagueStage?.maps_ex[0].name
            secondLeagueStageNameLabel.text = leagueStage?.maps_ex[1].name
        }
    }
}
